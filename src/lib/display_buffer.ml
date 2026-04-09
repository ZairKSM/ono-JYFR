
let steps_limit : int option ref = ref None
let show_latest_number : int option ref = ref None
let dim : int Queue.t = Queue.create ()
let push v = Queue.push v dim 
let pop () : int = Option.value (Queue.take_opt dim) ~default:0







