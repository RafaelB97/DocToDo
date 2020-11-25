<template>
  <div class="card card-body">
    {{ task.name }}
  </div>
</template>

<script>
export default {
  props: ['task'],
  data: function() {
    return {
      editing: false
    }
  }
}
</script>

<style>

</style>