Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D22DC433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Oct 2021 13:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60E1C61526
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Oct 2021 13:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhJRNqe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 18 Oct 2021 09:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232544AbhJRNo2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 18 Oct 2021 09:44:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB3BC61506;
        Mon, 18 Oct 2021 13:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634564115;
        bh=tLlmrcpE9T19JG8z6ljxodSS/pQwrpYkvqtifvX+ESw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XwUBZ4fcIJWQ+LqXzKYopTgVUjBKY6/fcl5B00avg6Y6dtGGNPfViRvIxZVWiLhhy
         8eRkFFMviLGgvaCX1mGEwbMsimnxcgo6qhQ5dDhpuVjiVQEOU29brFitSQcQ74W0Xc
         J18PpThfxQ9N1/hg6wAfQvCGZRR05a6nRBm+gfno6ujb8qlGdCNimY1L+nJ1GhZdbH
         DW+AsR+eL9ldADG8XHHGJ9XrAz479y+nJCP3JZ4lfuU+JCse/+vkX89Fkds/IGzY9H
         ft6Ya9Vk42HmY7nEceEoQk+NGWRCR8PBo2IzBHt+1inC3sj+2QIobcVRACb2f9C1wm
         9G4vX0LA93IXQ==
Message-ID: <eee87b139519684c1b2eb7d5f259580b29fc6841.camel@kernel.org>
Subject: Re: [PATCH v7 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Date:   Mon, 18 Oct 2021 16:35:12 +0300
In-Reply-To: <20211008203308.20963-2-jarkko@kernel.org>
References: <20211008203308.20963-1-jarkko@kernel.org>
         <20211008203308.20963-2-jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gRnJpLCAyMDIxLTEwLTA4IGF0IDIzOjMzICswMzAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
Cj4gK3N0YXRpYyB2b2lkIHNneF9udW1hX2V4aXQodm9pZCkKPiArewo+ICvCoMKgwqDCoMKgwqDC
oHN0cnVjdCBkZXZpY2UgKmRldjsKPiArwqDCoMKgwqDCoMKgwqBpbnQgbmlkOwo+ICsKPiArwqDC
oMKgwqDCoMKgwqBmb3IgKG5pZCA9IDA7IG5pZCA8IG51bV9wb3NzaWJsZV9ub2RlcygpOyBuaWQr
Kykgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkZXYgPSAmbm9kZV9kZXZpY2Vz
W25pZF0tPmRldjsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGRldikKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHN5c2ZzX3JlbW92
ZV9ncm91cCgmZGV2LT5rb2JqLCAmc2d4X25vZGVfYXR0cl9ncm91cCk7Cj4gK8KgwqDCoMKgwqDC
oMKgfQo+ICt9Cj4gKwo+ICtzdGF0aWMgYm9vbCBzZ3hfbnVtYV9pbml0KHZvaWQpCj4gK3sKPiAr
wqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgc2d4X251bWFfbm9kZSAqbm9kZTsKPiArwqDCoMKgwqDCoMKg
wqBpbnQgbmlkOwo+ICvCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4gKwo+ICvCoMKgwqDCoMKgwqDC
oGZvciAobmlkID0gMDsgbmlkIDwgbnVtX3Bvc3NpYmxlX25vZGVzKCk7IG5pZCsrKSB7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghc2d4X251bWFfbm9kZXNbbmlkXS5zaXpl
KQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY29udGlu
dWU7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBub2RlID0gJnNneF9udW1h
X25vZGVzW25pZF07Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5vZGUtPmRldiA9
ICZub2RlX2RldmljZXNbbmlkXS0+ZGV2Owo+ICsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgcmV0ID0gc3lzZnNfY3JlYXRlX2dyb3VwKCZub2RlLT5kZXYtPmtvYmosICZzZ3hfbm9k
ZV9hdHRyX2dyb3VwKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHJldCkg
ewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc2d4X251
bWFfZXhpdCgpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIGZhbHNlOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gK8Kg
wqDCoMKgwqDCoMKgfQoKSGVyZSdzIGEgbWlzdGFrZTogbm9kZS0+ZGV2IHNob3VsZCBiZSBvbmx5
IHNldCBhZnRlciBzeXNmZV9jcmVhdGVfZ3JvdXAoKS4KT3RoZXJ3aXNlLCBzeXNmc19yZW1vdmVf
Z3JvdXAoKSB3aWxsIGlzc3VlIGEgd2FybmluZyBpbiBzZ3hfbnVtYV9leGl0KCksIHdoZW4Kc2d4
X2NyZWF0ZV9ncm91cCgpIGlzIHVuc3VjY2Vzc2Z1bCwgYmVjYXVzZSB0aGUgZ3JvdXAgZG9lcyBu
b3QgZXhpc3QuCgpJJ2xsIGZpeCB0aGlzLCBhbmQgc2VuZCBhIG5ldyB2ZXJzaW9uLgoKL0phcmtr
bwoK

