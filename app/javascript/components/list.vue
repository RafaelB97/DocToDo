<template>
  <div class="col-3">
    <h6>{{ list.name }}</h6>
    <hr>

    <draggable v-model="list.tasks" group="task" @change="taskMoved(list, $event)">
      <task v-for="task in list.tasks" :key="task.id" :task="task"></task>
    </draggable>

    <a v-if="!editing" @click="startEditing">Add a task</a>
    <textarea v-if="editing" v-model="message" ref="message" class="form-control"></textarea>
    <button v-if="editing" @click="submitTask" class="btn btn-secondary">Add</button>
    <a v-if="editing" @click="editing=false">Cancel</a>
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
      message: ""
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
        url: "/tasks",
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
    }
  }
}
</script>

<style scoped>
</style>
