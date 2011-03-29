function input_detail(id, noneed) {
  var el = $(id);
  if (el.checked) {
    if (noneed) {
      alert("should hide");
    }else{
      alert("should show");
    }
  }else{
    if (noneed) {
      alert("should show");
    }else{
      alert("should hide");
    }
  }
  
}

