Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDEEC433F5
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Oct 2021 23:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 087B260F4C
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Oct 2021 23:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhJaXyk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 Oct 2021 19:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhJaXyj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 Oct 2021 19:54:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEDB960235;
        Sun, 31 Oct 2021 23:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635724327;
        bh=h8DUzgj0NTs9UOXTA3NHZGRu6A+/fu6F7WcAlrzPrGI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cWqFO6kJa/lzmpSQT918BKGo4pioiXUauZuTCSu9LOSNA/6aI1pyn9/y365g2U430
         rvmET646xPG/yzBXvGji/kmI4EfSxRsu0CawBFpZ9+eicT5DL2A8qd2M25WnZH4U1x
         xk7aMxiMNiZPNsqW3s4XOKrZI2gGe/kjmg+1RwxC7zOf1vtGV2LRZ/HXzUJfhcAN4U
         dDFuP98SBmtED7yCDJC1BkHY5x9ubpekCEfckQlt4jvOw5u+FlocZtNwEkXjVlVXfG
         syP0x4vVx04gm/u/WYsMQ68SszVjGo6/iOjv0Ug89GAkLHpOZjlE3gEsYYnWyz4Lcz
         dSAuMgV+9q37g==
Message-ID: <e2e347e08fc28a13e57aeb22ba5b3c54cde34f25.camel@kernel.org>
Subject: Re: [PATCH v9 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, reinette.chatre@intel.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org
Date:   Mon, 01 Nov 2021 01:52:04 +0200
In-Reply-To: <YX7uy3tZwBFQmAiR@kroah.com>
References: <20211029121857.477885-1-jarkko@kernel.org>
         <20211029121857.477885-2-jarkko@kernel.org> <YXwK7Wdi1VUK+1LS@kroah.com>
         <f0dc181d435cde51a9b81a70a0f47ff866d8cb91.camel@kernel.org>
         <YX7uy3tZwBFQmAiR@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gU3VuLCAyMDIxLTEwLTMxIGF0IDIwOjMwICswMTAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6Cj4gT24gU3VuLCBPY3QgMzEsIDIwMjEgYXQgMDc6Mzk6MzJQTSArMDIwMCwgSmFya2tvIFNh
a2tpbmVuIHdyb3RlOgo+ID4gPiA+ICtzdGF0aWMgc3NpemVfdCBzaXplX3Nob3coc3RydWN0IGRl
dmljZSAqZGV2LCBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQo+ID4g
PiA+ICt7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9uZyBzaXplID0gMDsKPiA+
ID4gPiArwqDCoMKgwqDCoMKgwqBpbnQgbmlkOwo+ID4gPiA+ICsKPiA+ID4gPiArwqDCoMKgwqDC
oMKgwqBmb3IgKG5pZCA9IDA7IG5pZCA8IG51bV9wb3NzaWJsZV9ub2RlcygpOyBuaWQrKykgewo+
ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoZGV2ID09IHNneF9udW1h
X25vZGVzW25pZF0uZGV2KSB7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBzaXplID0gc2d4X251bWFfbm9kZXNbbmlkXS5zaXplOwo+ID4gPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYnJlYWs7Cj4g
PiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiA+ID4gPiArwqDCoMKgwqDC
oMKgwqB9Cj4gPiA+ID4gKwo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBzeXNmc19lbWl0
KGJ1ZiwgIiVsdVxuIiwgc2l6ZSk7Cj4gPiA+ID4gK30KPiA+ID4gPiArREVWSUNFX0FUVFJfUk8o
c2l6ZSk7Cj4gPiA+IAo+ID4gPiBzdGF0aWM/Cj4gPiAKPiA+IFRoZSBuYW1lZCAoInNneCIpIGF0
dHJpYnV0ZSBncm91cCBpcyBleHBvcnRlZDoKPiA+IAo+ID4gZXh0ZXJuIGNvbnN0IHN0cnVjdCBh
dHRyaWJ1dGVfZ3JvdXAgc2d4X25vZGVfZ3JvdXA7Cj4gCj4gVGhhdCdzIGZpbmUsIEkgYW0gb2Jq
ZWN0aW5nIHRvIHRoZSBmYWN0IHRoYXQgeW91IG5vdyBoYXZlIGFkZGVkIGEgZ2xvYmFsCj4gc3lt
Ym9sIGNhbGxlZCBkZXZpY2VfYXR0cl9zaXplLsKgIFBsZWFzZSBtYWtlIHRoYXQgc3RhdGljIGFz
IHRoYXQgaXMgYQo+IFZFUlkgZ2VuZXJpYyBuYW1lLgoKUmlnaHQsIGdvdCBpdCEgVGhhbmsgeW91
LgoKL0phcmtrbwoK

