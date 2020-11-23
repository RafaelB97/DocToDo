<template>
  <div id="app" class="row">
    <p>{{ original_board.name }}</p>
    <p>{{ original_board }}</p>

    <div v-for="list in original_board.lists" :key="list.id" class="col-3">
      <h6>{{ list.name }}</h6>
      <hr>

      <div v-for="task in list.tasks" :key="task.id" class="card card-body">
        {{ task.name }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['original_board'],
  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
