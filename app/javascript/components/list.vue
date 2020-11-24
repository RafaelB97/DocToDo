<template>
  <div class="col-3">
    <h6>{{ list.name }}</h6>
    <hr>

    <draggable v-model="list.tasks" group="cards" @change="cardMoved(list, $event)">
      <div v-for="task in list.tasks" :key="task.id" class="card card-body">
        {{ task.name }}
      </div>
    </draggable>
    <div class="card card-body">
      <textarea v-model="message" class="form-control"></textarea>
      <button @click="submitTask" class="btn btn-secondary">Add</button>
    </div>
  </div>
</template>

<script>
import Rails from '@rails/ujs';
import draggable from 'vuedraggable'

export default {
  components: { draggable },

  props: ["list"],

  data: function() {
    return {
      message: ""
    }
  },

  methods: {
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
        }
      })
    },

    cardMoved: function(list, event) {
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
