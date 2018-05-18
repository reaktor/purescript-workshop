exports.momentFormatDate = function(dateStr){
  return require('moment')(dateStr).format('MMMM Do YYYY, h:mm:ss a')
}

exports.addNumbersJs = function(a){
  return function(b){
    return a + b
  }
}
