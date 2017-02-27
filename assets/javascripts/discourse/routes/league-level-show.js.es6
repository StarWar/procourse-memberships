import LeagueLevel from '../models/level';

export default Discourse.Route.extend({
  model(opts) {
  	return LeagueLevel.findById(opts.id);
  },

  setupController(controller, model) {
    var group = $.grep(this.currentUser.groups, function(group){ return group.id == parseInt(model[0].group); });
    if (group.length > 0){
      var memberExists = true;
    }
    else{
      var memberExists = false;
    }
    controller.setProperties({ model, memberExists: memberExists });
  }
});