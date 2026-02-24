Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C351A9FAA;
	Tue, 24 Feb 2026 00:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894039; cv=none; b=mgwdBXdXhHShovAEVKVDp0PTmDFV8QI4v9D8oVo3aFf9gavJI+FE9BFk+CY7hQLRBLYJu57d6elYNl/3T60UfBU48symOWI5K7oq2cWCyzs+UCNZ1GUuBOIRzmcjfkljAxCR0U0HrO0UrkDEieyecDdvL0a2R08IguU7UugRhHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894039; c=relaxed/simple;
	bh=EMToHs8ORkyKms8u1DiM5Ngs43sAs7JHJH+sabcs154=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UtvCvApT0BgT2fIN/2I6294aYypQKi/JmG3H758AZ/05LVJCHdo10Pw6RQ8g02fVwP1FTU1iFnQ5wo+TQoLN4MUqdn3BhwtWDrHP1CT/a8mY9SwqbNr1Q1Tusq9Upp2FeI5XRdprRLmT+6yvwll2CnEWlKEynaXI8uclVnMURPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
To: "Huang, Kai" <kai.huang@intel.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBb5aSW6YOo6YKu5Lu2XSBSZTogW1BBVENIXSB4ODYvc2d4OiBG?=
 =?utf-8?Q?ix_SRCU_list_traversal?=
Thread-Topic: =?utf-8?B?W+WklumDqOmCruS7tl0gUmU6IFtQQVRDSF0geDg2L3NneDogRml4IFNSQ1Ug?=
 =?utf-8?Q?list_traversal?=
Thread-Index: AQHclkJOidQwnTSolUCQ67isKsKKIbV80pqAgBRKCkA=
Date: Tue, 24 Feb 2026 00:30:13 +0000
Message-ID: <488bbc6d03eb4a8ebba1a7ff1b89f852@baidu.com>
References: <20260205015357.3635-1-lirongqing@baidu.com>
 <4adb6d4704e678e2d28b840ceaa7eda74cfac6ee.camel@intel.com>
In-Reply-To: <4adb6d4704e678e2d28b840ceaa7eda74cfac6ee.camel@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.3.13
X-FE-Policy-ID: 52:10:53:SYSTEM

DQo+ID4gUmVwbGFjZSBsaXN0X2Zvcl9lYWNoX2VudHJ5X3JjdSgpIHdpdGggbGlzdF9mb3JfZWFj
aF9lbnRyeV9zcmN1KCkgd2hlbg0KPiA+IHRyYXZlcnNpbmcgdGhlIGVuY2wtPm1tX2xpc3QgcHJv
dGVjdGVkIGJ5IFNSQ1UuIFRoaXMgZW5zdXJlcyBwcm9wZXINCj4gPiBzeW5jaHJvbml6YXRpb24g
YW5ub3RhdGlvbiBhbmQgYXZvaWRzIHBvdGVudGlhbCBsb2NrZGVwIHdhcm5pbmdzIGFib3V0DQo+
ID4gaW5jb3JyZWN0IFJDVSB1c2FnZS4NCj4gPg0KPiA+IFRoZSBsaXN0IGlzIHByb3RlY3RlZCBi
eSBlbmNsLT5zcmN1LCBub3QgUkNVLCBzbyB0aGUgU1JDVS1zcGVjaWZpYw0KPiA+IGl0ZXJhdG9y
IHdpdGggc3JjdV9yZWFkX2xvY2tfaGVsZCgpIGFubm90YXRpb24gaXMgcmVxdWlyZWQuDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+
IA0KPiBBY2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQpUaGFua3Mg
Zm9yIHJldmlld2luZyAsIGFuZCBwaW5nIA0KDQotTGkNCg0K
