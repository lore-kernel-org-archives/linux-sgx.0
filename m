Return-Path: <SRS0=S/Hi=XT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979F6C4320D
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 17:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E86A207FD
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 17:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569345625;
	bh=5CX8cWEh52M6eXKtDcxHy91sCi4jxF17tAgZFQmi99U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=vO/87A0d+ZmHoQFU15+ZDYYYL12R+e/bD91ZpTR8Do9+5v6RdIgveekEr3/CCacSh
	 xAY+5JXBxKQF6AV9yBCf6lIMbYD8bdCzEM52Ov6xkw80+w3QgOw4xq+a6BsPodsCR9
	 JCeNsjAsEvo+fw2XAUNZvXgp7LqE42UtAmMxR3XI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407128AbfIXRUY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Sep 2019 13:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407180AbfIXRUY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Sep 2019 13:20:24 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AA9D21841
        for <linux-sgx@vger.kernel.org>; Tue, 24 Sep 2019 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569345622;
        bh=5CX8cWEh52M6eXKtDcxHy91sCi4jxF17tAgZFQmi99U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HtIH7+DTaMfgDuFZZm2Q5aAdDqDincUCdHqcGVKO582dP9uJyMi4Wq916IUqI/qmS
         7f+DJAiql//0jbozXJbDs4mc5enc2OeDfKojA5aLwdnvnuSOC3lRl863t1Uow4dWPW
         8u5tZl8kH38BVl7F/UM8KUjJoKQWXSymCFbe1e2c=
Received: by mail-wm1-f41.google.com with SMTP id y135so2076468wmc.1
        for <linux-sgx@vger.kernel.org>; Tue, 24 Sep 2019 10:20:22 -0700 (PDT)
X-Gm-Message-State: APjAAAUtn+xphzqS4QsQLvVJ/DoHEMG80J0wPHeRuzCnzXONmlwiLz0/
        q7Q10va9sEbBcZTxxyd03W4RH9BXY6ZN4VTVemvtCg==
X-Google-Smtp-Source: APXvYqwgvpCgffx4sTD+nFnvIO2e9YCvIvNIqALEckl6CKy6QshFAP/F5Rr8p9fBeqJUvbt5mLvZaUoi/7foIbqrxMA=
X-Received: by 2002:a1c:6143:: with SMTP id v64mr1278559wmb.79.1569345620772;
 Tue, 24 Sep 2019 10:20:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <eed916f3-73e1-2695-4cd1-0b252ac9b553@intel.com> <20190914134136.GG9560@linux.intel.com>
 <8339d3c0-8e80-9cd5-948e-47733f7c29b7@intel.com> <20190916052349.GA4556@linux.intel.com>
In-Reply-To: <20190916052349.GA4556@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 24 Sep 2019 10:20:09 -0700
X-Gmail-Original-Message-ID: <CALCETrWDLX68Vi4=9Dicq9ATmJ5mv36bzrc02heNYaHaBeWumQ@mail.gmail.com>
Message-ID: <CALCETrWDLX68Vi4=9Dicq9ATmJ5mv36bzrc02heNYaHaBeWumQ@mail.gmail.com>
Subject: Re: [PATCH v22 00/24] Intel SGX foundations
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Lutomirski <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On Sep 15, 2019, at 10:24 PM, Jarkko Sakkinen <jarkko.sakkinen@linux.inte=
l.com> wrote:
>
> =EF=BB=BFOn Sat, Sep 14, 2019 at 08:32:38AM -0700, Dave Hansen wrote:
>>>> On 9/14/19 6:41 AM, Jarkko Sakkinen wrote:
>>>> The proposed LSM hooks give the granularity to make yes/no decision
>>>> based on the
>>>> * The origin of the source of the source for the enclave.
>>>> * The requested permissions for the added or mapped peage.
>>>> The hooks to do these checks are provided for mmap() and EADD
>>>> operations.
>>>> With just file permissions you can still limit mmap() by having a
>>>> privileged process to build the enclaves and pass the file descriptor
>>>> to the enclave user who can mmap() the enclave within the constraints
>>>> set by the enclave pages (their permissions refine the roof that you
>>>> can mmap() any memory range within an enclave).
>> The LSM hooks are presumably fixing a problem that these patches
>> introduce.  What's that problem?
>
> I've seen the claims that one would have to degrade one's LSM policy but
> I don't think that is true.
>
> With just UNIX permissions you have probably have to restrict the access
> to /dev/sgx/enclave to control who can build enclaves. The processes who
> do not have this privilege can mmap() the enclave once they get the file
> descriptor through forking or SCM_RIGHTS.

As the person who originally raised the issue, I feel like I should
rehash the issue:

Right now, using SELinux or probably other LSMs, it's straightforward
to prevent programs from having any executable pages whose contents
doesn't come from an approved (e.g. appropriately labeled) source.
With /dev/sgx/enclave, at least as initially designed, a process that
can open /dev/sgx/enclave can execute whatever bytes they want by
sticking them into an enclave.  I fully expect that people will want
to combine these things: have unprivileged users run only
admin-approved code but *also* allow unprivileged users to run
enclaves.

> *If anything*, I would rather investigate possibility to use keyring for
> enclave signer's public keys or perhaps having extended attribute for
> the signer (SHA256) in the enclave file that could be compared during
> the EINIT.

The latter is very much like the labeled-enclave-file thing we talked about=
.

>
> I think either can be considered post-upstreaming.

Indeed, as long as the overall API is actually compatible with these
types of restrictions.
