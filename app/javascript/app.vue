<template>
  <div id="app">
    <p>{{ original_board.name }}</p>
    <p>{{ original_board.lists }}</p>

    <draggable v-model="board.lists" group="lists" class="row dragArea" @end="listMoved">
      <list v-for="list in board.lists" :key="list.id" :list="list"></list>
    </draggable>
  </div>
</template>

<script>
import Rails from '@rails/ujs';
import draggable from 'vuedraggable'
import list from 'components/list'

export default {
  components: { draggable, list },

  props: ['original_board'],

  data: function () {
    return {
      messages: {},
      board: this.original_board
    }
  },

  methods: {
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
