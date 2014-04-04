var app = angular.module('pastedown', ['ngSanitize']);

app.run(function(){
  hljs.initHighlightingOnLoad();
  $(".js-tooltip").tooltip();

  //fb
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=607766852647879";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

  //g+
  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/platform.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();

  //twitter
  !function(d,s,id){
    var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
    if(!d.getElementById(id)){
      js=d.createElement(s);js.id=id;
      js.src=p+'://platform.twitter.com/widgets.js';
      fjs.parentNode.insertBefore(js,fjs);
    }
  }(document, 'script', 'twitter-wjs');
});

app.config(['$provide', function(provide){
  provide.factory('md', ['$http', '$q', function($http, $q){
    return {
      gfm: true,
      output: null,
      preview: function(input){
        var self = this;
        if(typeof(input) == "undefined"){
          input = "";
        }
        var deferred = $q.defer();
        var postData = {title: "preview", body: input};
        $http.post('/pastes/new/preview', postData).success(function(data){
          self.output = data.output;
          deferred.resolve();
        });
        return deferred.promise;
      },
      clear: function(){
        this.output = "";
      }
    };
  }]);
}]);

app.directive('preview', function(){
  return {
    restrict: 'E',
    scope: {},
    replace: true,
    controller: ['$scope', 'md', function($scope, md){
      $scope.md = md;
    }],
    template: '<div ng-bind-html="md.output"></div>'
  };
});

app.controller('editorCtrl', ['$http', '$scope', '$window', '$timeout', 'md', function($http, $scope, $window, $timeout, md){
  $scope.editMode = true;

  var path = $window.location.pathname;
  var regex = /^\/pastes\/(.*)\/.*/;

  if (regex.test(path)) {
    var resArray = regex.exec(path);
    var id = resArray[1];

    $http.get("/pastes/" + id + ".json").success(function(data){
      $scope.mdText = data.body;
    });
  } else {
    $scope.mdClass = "empty";
  }

  $scope.preview = function(){
    var promise = md.preview($scope.mdText);
    promise.then(function(){
      $scope.editMode = false;
      $timeout(function(){
        $('pre code').each(function(i, e) {hljs.highlightBlock(e)});
        MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
      }, 1);
    });
  };

  $scope.stopPreview = function(){
    $scope.editMode = true;
    md.clear();
  };

  $scope.$watch('mdText', function(value){
    if (typeof(value) == "undefined" || value == ""){
      $scope.previewDisable = true;
      $scope.mdClass = "empty";
    } else {
      $scope.previewDisable = false;
      $scope.mdClass = "";
    }
  });
}]);
