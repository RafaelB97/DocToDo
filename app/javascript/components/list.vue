<template>
  <div>
    <div class="handle">
      <div class="btn-group">
        <button type="button" class="btn" data-toggle="modal" v-bind:data-target="'#updateModal'+list.id"><strong>{{ list.name }}</strong></button>
        <button type="button" class="btn dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <span class="sr-only">Toggle Dropdown</span>
        </button>
        <div class="dropdown-menu">
          <a class="dropdown-item" data-toggle="modal" v-bind:data-target="'#deleteModal'+list.id">Delete list</a>
        </div>
      </div>

      <draggable v-model="list.tasks" group="task" handle=".handleTask" @change="taskMoved(list, $event)">
        <task v-for="task in list.tasks" :key="task.id" :task="task" :list="list"></task>
      </draggable>

      <div class="card card-body">
        <a v-if="!editing" @click="startEditing">Add a task</a>
        <textarea v-if="editing" v-model="message" ref="message" class="form-control"></textarea>
        <button v-if="editing" @click="submitTask" class="btn btn-secondary">Add</button>
        <a v-if="editing" @click="editing=false">Cancel</a>
      </div>
    </div>

    <!-- Modal update List -->
    <div class="modal fade" v-bind:id="'updateModal'+list.id" tabindex="-1" aria-labelledby="updateModal" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Update list</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <p>New name:</p>
            <input v-model='name' class='form-control'>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal" @click="name=list.name">Close</button>
            <button type="button" class="btn btn-primary" data-dismiss="modal" @click="updateList">Update</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal delete List -->
    <div class="modal fade" v-bind:id="'deleteModal'+list.id" tabindex="-1" aria-labelledby="deleteModal" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Delete list</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <p>Delete this list forever?</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <button type="button" class="btn btn-danger" data-dismiss="modal" @click='deleteList'>Delete</button>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import Rails from '@rails/ujs';
import draggable from 'vuedraggable'
import task from 'components/task'

export default {
  components: { draggable, task },

  props: ["list"],

  data: function() {
    return {
      editing: false,
      message: "",
      name: this.list.name
    }
  },

  methods: {
    startEditing: function() {
      this.editing = true
      this.$nextTick(() => this.$refs.message.focus())
    },

    submitTask: function() {
      var data = new FormData
      data.append("task[list_id]", this.list.id)
      data.append("task[name]", this.message)

      Rails.ajax({
        url: "/tasks/createFromGroup",
        type: "POST",
        data: data,
        dataType: "json",
        success: data => {
          const index = window.store.board.lists.findIndex(item => item.id === this.list.id)
          window.store.board.lists[index].tasks.push(data)
          this.message = ""
          this.$nextTick(() => this.$refs.message.focus())
        }
      })
    },

    taskMoved: function(list, event) {
      const evt = event.added || event.moved
      if (evt) {
        const element = evt.element
        var data = new FormData
        data.append("task[list_id]", list.id)
        data.append("task[position]", evt.newIndex + 1)

        Rails.ajax({
          url: `/tasks/${element.id}/move`,
          type: "PATCH",
          data: data,
          dataType: "json"
        })
      }
    },

    updateList: function() {
      var data = new FormData
      data.append('list[name]', this.name)
      Rails.ajax({
        url: `/lists/${this.list.id}`,
        type: 'PATCH',
        data: data,
        dataType: 'json',
        success: data => {
          this.list.name = this.name
        }
      })
    },

    deleteList: function() {
      Rails.ajax({
        url: `/lists/${this.list.id}`,
        type: 'DELETE',
        success: data => {
          console.log(data)
          location.reload()
        }
      })
    }
  }
}
</script>

<style scoped>
</style>
