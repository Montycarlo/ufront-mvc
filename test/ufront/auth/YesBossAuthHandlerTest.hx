package ufront.auth;

import utest.Assert;
import ufront.auth.YesBossAuthHandler;
import ufront.auth.*;
using ufront.test.TestUtils;

class YesBossAuthHandlerTest {

	public function new() {}

	public function beforeClass():Void {}

	public function afterClass():Void {}

	public function setup():Void {}

	public function teardown():Void {}

	public function testYesBoss():Void {
		var yb:UFAuthHandler = new YesBossAuthHandler();
		Assert.isTrue( yb.isLoggedIn() );
		yb.requireLogin();
		Assert.isTrue( yb.isLoggedInAs( new BossUser() ) );
		yb.requireLoginAs( new BossUser() );
		Assert.isTrue( yb.hasPermission( HaveCake ) );
		Assert.isTrue( yb.hasPermissions( [ HaveCake, EatCake ] ) );
		yb.requirePermission( EatCake );
		yb.requirePermissions( [ HaveCake, EatCake ] );
		Assert.equals( "The Boss", yb.currentUser.userID );
	}

	public function testBossUser():Void {
		var boss = new BossUser();
		Assert.equals( "The Boss", boss.userID );
		Assert.isTrue( boss.can(HaveCake) );
		Assert.isTrue( boss.can([HaveCake,EatCake]) );
	}
}

enum TestPermissions {
	HaveCake;
	EatCake;
}
