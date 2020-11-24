<template>
  <div id="app">
    <p>{{ original_board.name }}</p>
    <p>{{ original_board.lists }}</p>

    <draggable v-model="board.lists" group="lists" class="row dragArea" @end="listMoved">
      <div v-for="list in board.lists" :key="list.id" class="col-3">
        <h6>{{ list.name }}</h6>
        <hr>

        <div v-for="task in list.tasks" :key="task.id" class="card card-body">
          {{ task.name }}
        </div>
        <div class="card card-body">
          <textarea v-model="messages[list.id]" class="form-control"></textarea>
          <button @click="submitTask(list.id)" class="btn btn-secondary">Add</button>
        </div>
      </div>
    </draggable>
  </div>
</template>

<script>
import Rails from '@rails/ujs';
import draggable from 'vuedraggable'

export default {
  components: { draggable },

  props: ['original_board'],

  data: function () {
    return {
      messages: {},
      board: this.original_board
    }
  },

  methods: {
    submitTask: function(list_id) {
      console.log(this.messages[list_id])
      var data = new FormData
      data.append("task[list_id]", list_id)
      data.append("task[name]", this.messages[list_id])

      Rails.ajax({
        url: "/tasks",
        type: "POST",
        data: data,
        dataType: "json",
        success: data => {
          const index = this.board.lists.findIndex(item => item.id === list_id)
          this.board.lists[index].tasks.push(data)
          this.messages[list_id] = undefined
        }
      })
    },

    listMoved: function(event) {
      console.log(event)
      var data = new FormData
      data.append("list[position]", event.newIndex + 1)

      Rails.ajax({
        url: `/lists/${this.board.lists[event.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json"
      })
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

.dragArea {
  min-height: 10px;
}
</style>
