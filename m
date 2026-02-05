Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B95B277CB8;
	Thu,  5 Feb 2026 21:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770326200; cv=none; b=k1Ze1P1cBZ/PBXBmPxcygNcaxf+J+xLQVu/fOubcltniZ+zeYW/YYj5guXuUY0MrKoUj6WJU03MnNJu9Us19rxGf/vlz1663UF1hLRTY33xfdgj/3R5roolLokrK47Alkj7CTlVnZhkkqMH8mlVJd8mRcjKTz7D1izdZGoKLKo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770326200; c=relaxed/simple;
	bh=hB7jezoAYYyK4emzfVvpQ1rhpy+wo8CO2LPijaJWaxQ=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RTzCBPNl+qbMCuG5c5BLacDUWzISU51O/uHuEelywWzghlaH7KohYz91vI+DZCQulgRSwhGwvnrP3hxT7MKsVZgo6BXN5QgeuCt9GSOtFpQY1C/ID7RA9wd+NZRAGEOk6TphshThsb91T/+1ax50BfTm5iTxR4WtrGIYIpwQMOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Dave Hansen <dave.hansen@intel.com>, Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBb5aSW6YOo6YKu5Lu2XSBSZTogW1BBVENIXSB4ODYvc2d4OiBG?=
 =?utf-8?Q?ix_SRCU_list_traversal?=
Thread-Topic: =?utf-8?B?W+WklumDqOmCruS7tl0gUmU6IFtQQVRDSF0geDg2L3NneDogRml4IFNSQ1Ug?=
 =?utf-8?Q?list_traversal?=
Thread-Index: AQHclkJOidQwnTSolUCQ67isKsKKIbVz32AAgAC5ImA=
Date: Thu, 5 Feb 2026 21:15:40 +0000
Message-ID: <cd326e6b8aa745688628bfcef94aa9b9@baidu.com>
References: <20260205015357.3635-1-lirongqing@baidu.com>
 <1460dd28-7441-4bbf-8b48-ab215c195425@intel.com>
In-Reply-To: <1460dd28-7441-4bbf-8b48-ab215c195425@intel.com>
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
X-FEAS-Client-IP: 172.31.50.45
X-FE-Policy-ID: 52:10:53:SYSTEM

PiBPbiAyLzQvMjYgMTc6NTMsIGxpcm9uZ3Fpbmcgd3JvdGU6DQo+ID4gUmVwbGFjZSBsaXN0X2Zv
cl9lYWNoX2VudHJ5X3JjdSgpIHdpdGggbGlzdF9mb3JfZWFjaF9lbnRyeV9zcmN1KCkgd2hlbg0K
PiA+IHRyYXZlcnNpbmcgdGhlIGVuY2wtPm1tX2xpc3QgcHJvdGVjdGVkIGJ5IFNSQ1UuIFRoaXMg
ZW5zdXJlcyBwcm9wZXINCj4gPiBzeW5jaHJvbml6YXRpb24gYW5ub3RhdGlvbiBhbmQgYXZvaWRz
IHBvdGVudGlhbCBsb2NrZGVwIHdhcm5pbmdzIGFib3V0DQo+ID4gaW5jb3JyZWN0IFJDVSB1c2Fn
ZS4NCj4gDQo+IERvZXMgbG9ja2RlcCB0cmlwIG9uIHRoaXMgdG9kYXk/DQo+IA0KPiA+IFRoZSBs
aXN0IGlzIHByb3RlY3RlZCBieSBlbmNsLT5zcmN1LCBub3QgUkNVLCBzbyB0aGUgU1JDVS1zcGVj
aWZpYw0KPiA+IGl0ZXJhdG9yIHdpdGggc3JjdV9yZWFkX2xvY2tfaGVsZCgpIGFubm90YXRpb24g
aXMgcmVxdWlyZWQuDQo+IA0KPiBGcm9tIGEgcXVpY2sgbG9vaywgbGlzdF9mb3JfZWFjaF9lbnRy
eV9yY3UoKSBzdGlsbCBzZWVtcyAqcmVhbGx5KiBjb21tb24NCj4gdW5kZXIgU1JDVS4gSXQgYWxz
byBsb29rcyBsaWtlIGxpc3RfZm9yX2VhY2hfZW50cnlfc3JjdSgpIGlzIGEgcmVsYXRpdmVseSBy
ZWNlbnQNCj4gKDIwMjApIGFkZGl0aW9uIHRvIHRoZSBrZXJuZWwuDQo+IA0KPiBTbywgdGhpcyB3
YXNuJ3QgYSBidWcgd2hlbiB0aGUgU0dYIGNvZGUgd2VudCBpbiwgYnV0IHN0YXJ0ZWQgY2F1c2lu
ZyBhDQo+IHByb2JsZW0gYXQgc29tZSBwb2ludD8gRGlkIGxvY2tkZXAgYWRkIHNvbWUgUkNVIHdh
cm5pbmdzIG9yIHNvbWV0aGluZw0KPiB0aGF0IG1hZGUgdGhpcyBuZWNlc3Nhcnk/DQo+IA0KPiBU
aGUgcGF0Y2ggc2VlbXMgbG9naWNhbCBhbmQgYWxsLiBJIGp1c3QgZmVlbCBsaWtlIEknbSBtaXNz
aW5nIHRoZSBiaWdnZXIgcGljdHVyZS4NCg0KU2VlbSB0aGlzIHBhdGNoIGFkZHMgdGhlIGNoZWNr
DQoNCmNvbW1pdCAyODg3NTk0NWJhOThkMWI0N2E4YTcwNjgxMmI2NDk0ZDE2NWJiMGEwDQpBdXRo
b3I6IEpvZWwgRmVybmFuZGVzIChHb29nbGUpIDxqb2VsQGpvZWxmZXJuYW5kZXMub3JnPg0KRGF0
ZTogICBUdWUgSnVsIDE2IDE4OjEyOjIyIDIwMTkgLTA0MDANCg0KICAgIHJjdTogQWRkIHN1cHBv
cnQgZm9yIGNvbnNvbGlkYXRlZC1SQ1UgcmVhZGVyIGNoZWNraW5nDQoNCiAgICBUaGlzIGNvbW1p
dCBhZGRzIFJDVS1yZWFkZXIgY2hlY2tzIHRvIGxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KCkgYW5k
DQogICAgaGxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KCkuICBUaGVzZSBjaGVja3MgYXJlIG9wdGlv
bmFsLCBhbmQgYXJlIGluZGljYXRlZA0KICAgIGJ5IGEgbG9ja2RlcCBleHByZXNzaW9uIHBhc3Nl
ZCB0byBhIG5ldyBvcHRpb25hbCBhcmd1bWVudCB0byB0aGVzZSB0d28NCiAgICBtYWNyb3MuICBJ
ZiB0aGlzIG9wdGlvbmFsIGxvY2tkZXAgZXhwcmVzc2lvbiBpcyBvbWl0dGVkLCB0aGVzZSB0d28g
bWFjcm9zDQogICAgYWN0IGFzIGJlZm9yZSwgY2hlY2tpbmcgZm9yIGFuIFJDVSByZWFkLXNpZGUg
Y3JpdGljYWwgc2VjdGlvbi4NCg0KICAgIFNpZ25lZC1vZmYtYnk6IEpvZWwgRmVybmFuZGVzIChH
b29nbGUpIDxqb2VsQGpvZWxmZXJuYW5kZXMub3JnPg0KICAgIFsgcGF1bG1jazogVXBkYXRlIHRv
IGVsaW1pbmF0ZSByZXR1cm4gd2l0aGluIG1hY3JvIGFuZCB1cGRhdGUgY29tbWVudC4gXQ0KICAg
IFNpZ25lZC1vZmYtYnk6IFBhdWwgRS4gTWNLZW5uZXkgPHBhdWxtY2tAbGludXguaWJtLmNvbT4N
Cg0KDQpBbmQgdGhlcmUgYXJlIHNldmVyYWwgc2ltaWxhciBmaXhlczoNCg0KZDY4MTEwNyBudm1l
LW11bHRpcGF0aDogZml4IHN1c3BpY2lvdXMgUkNVIHVzYWdlIHdhcm5pbmcNCjVkZDE4ZjAgbnZt
ZS9tdWx0aXBhdGg6IEZpeCBSQ1UgbGlzdCB0cmF2ZXJzYWwgdG8gdXNlIFNSQ1UgcHJpbWl0aXZl
DQo2ZDFjNjk5IG52bWUvaG9zdDogRml4IFJDVSBsaXN0IHRyYXZlcnNhbCB0byB1c2UgU1JDVSBw
cmltaXRpdmUNCjZhMGM2MTcgS1ZNOiBldmVudGZkOiBGaXggZmFsc2UgcG9zaXRpdmUgUkNVIHVz
YWdlIHdhcm5pbmcNCmRmOWEzMGYga3ZtOiBtbXU6IHBhZ2VfdHJhY2s6IEZpeCBSQ1UgbGlzdCBB
UEkgdXNhZ2UNCg0KW0xpLFJvbmdxaW5nXSANCiANCg0K
