export default dateUpdater;

const dateUpdater = $(document).on('turbolinks:load', () => {
  $('#datePickerInput').datepicker({
    todayHighlight: true,
    format: 'yyyy-mm-dd',
    autoClose: true,
  });

  return $('#datePicker').click(() =>
    $('#datePickerInput')
      .datepicker('show')
      .on('changeDate', e => {
        if ($(e.target).data('reload-path')) {
          return Turbolinks.visit(
            `/dates/${e.format()}?reload_path=${$(e.target).data(
              'reload-path',
            )}/${e.format()}`,
          );
        } else {
          return Turbolinks.visit(`/dates/${e.format()}`);
        }
      }),
  );
});
