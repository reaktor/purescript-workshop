exports.formatTime = function(timeStr){
  return require('moment')(timeStr).format('MMM D YYYY')
}
