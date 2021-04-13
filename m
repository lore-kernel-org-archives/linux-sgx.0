Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200C4C433ED
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Apr 2021 07:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F02D5613BB
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Apr 2021 07:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhDMHUN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 13 Apr 2021 03:20:13 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3526 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbhDMHUN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 13 Apr 2021 03:20:13 -0400
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FKH4V6DRqzRcCx;
        Tue, 13 Apr 2021 15:17:46 +0800 (CST)
Received: from dggeml709-chm.china.huawei.com (10.3.17.139) by
 DGGEML403-HUB.china.huawei.com (10.3.17.33) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 13 Apr 2021 15:19:51 +0800
Received: from dggeml759-chm.china.huawei.com (10.1.199.138) by
 dggeml709-chm.china.huawei.com (10.3.17.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 13 Apr 2021 15:19:51 +0800
Received: from dggeml759-chm.china.huawei.com ([10.1.199.138]) by
 dggeml759-chm.china.huawei.com ([10.1.199.138]) with mapi id 15.01.2106.013;
 Tue, 13 Apr 2021 15:19:51 +0800
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        pmail_hulkci <hulkci@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggLW5leHRdIHg4Ni9zZ3g6IE1ha2Ugc3ltYm9sICdz?=
 =?utf-8?B?Z3hfdmVwY192bV9vcHMnIHN0YXRpYw==?=
Thread-Topic: [PATCH -next] x86/sgx: Make symbol 'sgx_vepc_vm_ops' static
Thread-Index: AQHXL7OSMHyqG4YsjEG7qN2oEumJnqqwoh2AgAFo8DA=
Date:   Tue, 13 Apr 2021 07:19:51 +0000
Message-ID: <49155f7aa87a49c79fdfa079bc69ec89@huawei.com>
References: <20210412160023.193850-1-weiyongjun1@huawei.com>
 <20210412174649.GG24283@zn.tnic>
In-Reply-To: <20210412174649.GG24283@zn.tnic>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.48]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiANCj4gT24gTW9uLCBBcHIgMTIsIDIwMjEgYXQgMDQ6MDA6MjNQTSArMDAwMCwgV2VpIFlvbmdq
dW4gd3JvdGU6DQo+ID4gVGhlIHNwYXJzZSB0b29sIGNvbXBsYWlucyBhcyBmb2xsb3dzOg0KPiA+
DQo+ID4gYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvdmlydC5jOjk1OjM1OiB3YXJuaW5nOg0KPiA+
ICBzeW1ib2wgJ3NneF92ZXBjX3ZtX29wcycgd2FzIG5vdCBkZWNsYXJlZC4gU2hvdWxkIGl0IGJl
IHN0YXRpYz8NCj4gPg0KPiA+IFRoaXMgc3ltYm9sIGlzIG5vdCB1c2VkIG91dHNpZGUgb2Ygdmly
dC5jLCBzbyB0aGlzIGNvbW1pdCBtYXJrcyBpdA0KPiA+IHN0YXRpYy4NCj4gDQo+IEZvciB0aGUg
ZnV0dXJlOg0KPiANCj4gQXZvaWQgaGF2aW5nICJUaGlzIHBhdGNoIiBvciAiVGhpcyBjb21taXQi
IGluIHRoZSBjb21taXQgbWVzc2FnZS4gSXQgaXMgdGF1dG9sb2dpY2FsbHkgdXNlbGVzcy4NCj4g
DQo+IEFsc28sIGRvDQo+IA0KPiAkIGdpdCBncmVwICdUaGlzIHBhdGNoJyBEb2N1bWVudGF0aW9u
L3Byb2Nlc3MNCj4gDQo+IGZvciBtb3JlIGRldGFpbHMuDQo+IA0KPiBUaHguDQoNCg0KR290IGl0
LCB0aGFua3MuDQoNClJlZ2FyZHMsDQpXZWkgWW9uZ2p1bg0KDQo=
