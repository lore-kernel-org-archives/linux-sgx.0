Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DE21E5207;
	Tue, 24 Feb 2026 02:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771901594; cv=none; b=JU1dOUUh03YWIBvomR5kde82rliXLz6ZqeFxGZgWzUprpiZB96GFaW6HDqceaQnmHCgmxYTgciRrYfVAGkKdm1hBA65O+/pwyJqLwirn2+/iFs1HVjHHj3k8PJkIM+G/dseqbD7gIqtZ6lVHi+Z09uODdiHEOFacQriNre0IvEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771901594; c=relaxed/simple;
	bh=sf/Mg89B7mpgyj3rT0Wtz1vvPH0076Vnamu+y9iufEI=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dWp2zkLn+K2Akl6qJgmxSfZf2U6mVaWVLXBfEyx3CauZNMEvRWsHkFhQhjZ4aWxuEHZAiSD3B5vOgB8+GRqCcaKwKG27QTZSsAGMpYoYxefkBhM51TkT1T6K6ETdg8Or/PdvLFuHYLh9Dj6oSAP2PPv/3ddyrvOt5I05BAHZnQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
To: Dave Hansen <dave.hansen@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFvlpJbpg6jpgq7ku7ZdIFJlOiBbUEFUQ0hdIHg4?=
 =?utf-8?Q?6/sgx:_Fix_SRCU_list_traversal?=
Thread-Topic: =?utf-8?B?562U5aSNOiBb5aSW6YOo6YKu5Lu2XSBSZTogW1BBVENIXSB4ODYvc2d4OiBG?=
 =?utf-8?Q?ix_SRCU_list_traversal?=
Thread-Index: AQHclkJOidQwnTSolUCQ67isKsKKIbV80pqAgBRKCkD//4aaAIAAn1fQ
Date: Tue, 24 Feb 2026 02:51:49 +0000
Message-ID: <ccf8c68db6d14de99bd8404ea9bd3ac2@baidu.com>
References: <20260205015357.3635-1-lirongqing@baidu.com>
 <4adb6d4704e678e2d28b840ceaa7eda74cfac6ee.camel@intel.com>
 <488bbc6d03eb4a8ebba1a7ff1b89f852@baidu.com>
 <a79e6300-4188-4670-b801-0f64bcffb673@intel.com>
In-Reply-To: <a79e6300-4188-4670-b801-0f64bcffb673@intel.com>
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
X-FEAS-Client-IP: 172.31.50.46
X-FE-Policy-ID: 52:10:53:SYSTEM

PiA+Pj4gVGhlIGxpc3QgaXMgcHJvdGVjdGVkIGJ5IGVuY2wtPnNyY3UsIG5vdCBSQ1UsIHNvIHRo
ZSBTUkNVLXNwZWNpZmljDQo+ID4+PiBpdGVyYXRvciB3aXRoIHNyY3VfcmVhZF9sb2NrX2hlbGQo
KSBhbm5vdGF0aW9uIGlzIHJlcXVpcmVkLg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IExp
IFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPj4gQWNrZWQtYnk6IEthaSBIdWFu
ZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiBUaGFua3MgZm9yIHJldmlld2luZyAsIGFuZCBw
aW5nDQo+IA0KPiBJdCdzIGEgbGlnaHQgTkFLIGZyb20gbWUgd2l0aCB0aGUgY3VycmVudCBjaGFu
Z2Vsb2cuDQo+IA0KPiBJIHdhbnQgYSB3ZWUgYml0IG1vcmUgYmFja2dyb3VuZCBhbmQgc29tZSBy
ZWFzb25pbmcgX3NvbWV3aGVyZV8gYWJvdXQNCj4gd2h5IHRoaXMgd2Fzbid0IGEgYnVnIHdoZW4g
dGhlIGNvZGUgd2VudCBpbiBvcmlnaW5hbGx5IGJ1dCBhcmd1YWJseSBiZWNhbWUgYQ0KPiBidWds
ZXQgYXQgc29tZSBwb2ludC4NCg0KDQpUaGUgYnVnZ3kgY29tbWl0IGlzIDE3MjhhYjU0YjRiZSAo
Ing4Ni9zZ3g6IEFkZCBhIHBhZ2UgcmVjbGFpbWVyIikgaW4gdjUuMTEsIGl0IHNob3VsZCB1c2Ug
bGlzdF9mb3JfZWFjaF9lbnRyeV9zcmN1KCl3aGljaCBpcyBpbnRyb2R1Y2VkIGluIHY1LjEwLCBz
byBJIHJld3JpdGUgdGhlIGNvbW1pdCBtZXNzYWdlIGFzIGJlbG93LCBpcyBpdCBvaz8NCg0KDQoN
CiAgICB4ODYvc2d4OiBVc2UgbGlzdF9mb3JfZWFjaF9lbnRyeV9zcmN1KCkgZm9yIG1tX2xpc3Qg
dHJhdmVyc2FsDQoNCiAgICBJbiBjb21taXQgMTcyOGFiNTRiNGJlICgieDg2L3NneDogQWRkIGEg
cGFnZSByZWNsYWltZXIiKSAodjUuMTEpLA0KICAgIGxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KCkg
d2FzIHVzZWQgdG8gdHJhdmVyc2UgdGhlIGVuY2xhdmUncyBtbV9saXN0Lg0KICAgIEhvd2V2ZXIs
IHRoaXMgaXMgaW5jb3JyZWN0IGJlY2F1c2UgdGhlIGxpc3QgaXMgcHJvdGVjdGVkIGJ5IGEgU2xl
ZXBhYmxlDQogICAgUkNVIChTUkNVKSBsb2NrIChlbmNsLT5zcmN1KS4NCg0KICAgIFNpbmNlIGNv
bW1pdCAyODg3NTk0NWJhOTggKCJyY3U6IEFkZCBzdXBwb3J0IGZvciBjb25zb2xpZGF0ZWQtUkNV
IHJlYWRlcg0KICAgIGNoZWNraW5nIikgKHY1LjQpLCBSQ1UgbG9ja2RlcCBjaGVja2luZyBoYXMg
YmVjb21lIHN0cmljdGVyLiBXaGVuDQogICAgQ09ORklHX1BST1ZFX1JDVSBpcyBlbmFibGVkLCB1
c2luZyB0aGUgc3RhbmRhcmQgbGlzdF9mb3JfZWFjaF9lbnRyeV9yY3UoKQ0KICAgIHdoaWxlIG9u
bHkgaG9sZGluZyBhbiBTUkNVIGxvY2sgdHJpZ2dlcnMgInN1c3BpY2lvdXMgUkNVIHVzYWdlIiBm
YWxzZQ0KICAgIHBvc2l0aXZlIHdhcm5pbmdzLCBhcyBpdCBkb2VzIG5vdCByZWNvZ25pemUgU1JD
VSByZWFkLXNpZGUgY3JpdGljYWwNCiAgICBzZWN0aW9ucy4NCg0KICAgIEZpeCB0aGlzIGJ5IHN3
aXRjaGluZyB0byBsaXN0X2Zvcl9lYWNoX2VudHJ5X3NyY3UoKSwgd2hpY2ggd2FzDQogICAgaW50
cm9kdWNlZCBzcGVjaWZpY2FsbHkgZm9yIHRoaXMgcHVycG9zZSBpbiBjb21taXQgYWUyMjEyYTcy
MTYNCiAgICAoInJjdWxpc3Q6IEludHJvZHVjZSBsaXN0L2hsaXN0X2Zvcl9lYWNoX2VudHJ5X3Ny
Y3UoKSBtYWNyb3MiKSAodjUuMTApLg0KICAgIFRoaXMgY29ycmVjdGx5IGFzc29jaWF0ZXMgdGhl
IHRyYXZlcnNhbCB3aXRoIHRoZSBTUkNVIGxvY2sgYW5kDQogICAgZWxpbWluYXRlcyB0aGUgbG9j
a2RlcCB3YXJuaW5ncy4NCg0KICAgIEZpeGVzOiAxNzI4YWI1NGI0YmUgKCJ4ODYvc2d4OiBBZGQg
YSBwYWdlIHJlY2xhaW1lciIpDQogICAgU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9u
Z3FpbmdAYmFpZHUuY29tPg0KDQoNCg==
