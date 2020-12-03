<template>
  <div>
    <div class="handleTask">
      <div class="card card-body" data-toggle="modal" v-bind:data-target="'#updateModalTask'+task.id">
        {{ task.name }}
      </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" v-bind:id="'updateModalTask'+task.id" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Update task</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <input v-model='name' class='form-control'>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-danger mr-auto" data-dismiss="modal" data-toggle="modal" v-bind:data-target="'#deleteModalTask'+task.id">Delete</button>
            <button type="button" class="btn btn-secondary" data-dismiss="modal" @click='name=task.name'>Close</button>
            <button type="button" class="btn btn-primary" data-dismiss="modal" @click='save'>Save changes</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal delete List -->
    <div class="modal fade" v-bind:id="'deleteModalTask'+task.id" tabindex="-1" aria-labelledby="deleteModalTask" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Delete task</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <p>Delete this task forever?</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <button type="button" class="btn btn-danger" data-dismiss="modal" @click='deleteTask'>Delete</button>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import Rails from '@rails/ujs';

export default {
  props: ['task', 'list'],
  data: function() {
    return {
      editing: false,
      name: this.task.name
    }
  },

  methods: {
    closeModal: function(event) {
      if (event.target.classList.contains('modal')) { this.editing = false }
    },
    save: function() {
      var data = new FormData
      data.append('task[name]', this.name)

      Rails.ajax({
        url: `/tasks/${this.task.id}`,
        type: "PATCH",
        data: data,
        dataType: "json",
        success: data => {
          const list_index = window.store.board.lists.findIndex((item) => item.id === this.list.id)
          const task_index = window.store.board.lists[list_index].tasks.findIndex((item) => item.id === this.task.id)
          window.store.board.lists[list_index].tasks.splice(task_index, 1, data)

          this.editing = false
        }
      })
    },

    deleteTask: function() {
      Rails.ajax({
        url: `/tasks/${this.task.id}`,
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

<style>

</style>