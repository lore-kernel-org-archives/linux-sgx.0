Return-Path: <SRS0=jkgx=6V=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A71BC38A24
	for <linux-sgx@archiver.kernel.org>; Thu,  7 May 2020 16:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06FE1215A4
	for <linux-sgx@archiver.kernel.org>; Thu,  7 May 2020 16:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L6kBF/1Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgEGQtc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 7 May 2020 12:49:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52302 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726467AbgEGQtb (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 7 May 2020 12:49:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588870169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J3eMS0q6Ky8AS+NYfRImuhd7GvbGAICUz7ULX5bxR6k=;
        b=L6kBF/1YK0K1N6Hr51sU6l00DXLKvd2HV06qiSH8XI5NVmU5OXHYV5y2g2jpm9e2zWBAOt
        qS/KKfe8WGay51qGO+tRyZgwVUHZtN+DNLh81/6B24ac4FxAm5csAwQJL+IZxF2iQWSp5w
        jJF5jcOOXr6g28Vvylcg9ht3eQEeaF4=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-hvtTTJNWNXeoGk-6nLpxww-1; Thu, 07 May 2020 12:49:26 -0400
X-MC-Unique: hvtTTJNWNXeoGk-6nLpxww-1
Received: by mail-il1-f199.google.com with SMTP id l18so6780932ilg.0
        for <linux-sgx@vger.kernel.org>; Thu, 07 May 2020 09:49:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J3eMS0q6Ky8AS+NYfRImuhd7GvbGAICUz7ULX5bxR6k=;
        b=G1gwMnVZZ1stAdw/ckzyi929cTaRVjXBF3HolDfdtWoG6skwYTpHLXXI4LVWeRRmmo
         DX9bcqj3AlvRXDD2bleOzRO9/ikvCm+6H3Wo3h6+MioflMpL8tX/ettPi7Olc4xueR/P
         Vd3XKNIITCTxdCj4LNuvVyTkP+liW6CQCBpIqJNH2bjH1UK32cL65EctmXNDFzTaN8rf
         ELI7cUQwz6L3XoPyTwU5kbmSBdgWorujdRZLRjevEaTGCZFBhVCRbEjw00pxI8wPyF96
         SAWHZdLly0csttwrMwPVAK6sOL48U+Sl6ReQK+dMbjVVxPNxeRedDAFZLh2rEkmorkEO
         0Dug==
X-Gm-Message-State: AGi0Pubb48ORDbTrXgSIhFt51HgE6smrY2TcUhKrICt0r/iLq95WifAz
        Xg0p1OBOWPUTJN/icvcLSRT3x7rv0q3AiVXuendL+jX5S8Kyq6/c+ofQaWbK++gx3wGwuIo41Kx
        yD8lklZWDiO3DAZtOd0WUCTAstiR5/tfppioq
X-Received: by 2002:a92:84c1:: with SMTP id y62mr15525279ilk.116.1588870165907;
        Thu, 07 May 2020 09:49:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypKExP8SbbQHzz9rGOw8+hXCd/N5kkr6E1Ib5f74K5TeISNkZvDOTH//u7ziLHw2xgbTFPXNqC937+BrUayLQ+U=
X-Received: by 2002:a92:84c1:: with SMTP id y62mr15525255ilk.116.1588870165638;
 Thu, 07 May 2020 09:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com>
 <20200506221422.GK3329@linux.intel.com> <op.0j8dm0zzwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
In-Reply-To: <op.0j8dm0zzwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Thu, 7 May 2020 12:49:15 -0400
Message-ID: <CAOASepNVckens=wiWpHj291EAo0ndi7GCVHd9j7BPn8rjy7Ykg@mail.gmail.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 7, 2020 at 1:03 AM Haitao Huang
<haitao.huang@linux.intel.com> wrote:
>
> On Wed, 06 May 2020 17:14:22 -0500, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>
> > On Wed, May 06, 2020 at 05:42:42PM -0400, Nathaniel McCallum wrote:
> >> Tested on Enarx. This requires a patch[0] for v29 support.
> >>
> >> Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
> >>
> >> However, we did uncover a small usability issue. See below.
> >>
> >> [0]:
> >> https://github.com/enarx/enarx/pull/507/commits/80da2352aba46aa7bc6b4d1fccf20fe1bda58662
> >
> > ...
> >
> >> > * Disallow mmap(PROT_NONE) from /dev/sgx. Any mapping (e.g.
> >> anonymous) can
> >> >   be used to reserve the address range. Now /dev/sgx supports only
> >> opaque
> >> >   mappings to the (initialized) enclave data.
> >>
> >> The statement "Any mapping..." isn't actually true.
> >>
> >> Enarx creates a large enclave (currently 64GiB). This worked when we
> >> created a file-backed mapping on /dev/sgx/enclave. However, switching
> >> to an anonymous mapping fails with ENOMEM. We suspect this is because
> >> the kernel attempts to allocate all the pages and zero them but there
> >> is insufficient RAM available. We currently work around this by
> >> creating a shared mapping on /dev/zero.
> >
> > Hmm, the kernel shouldn't actually allocate physical pages unless they're
> > written.  I'll see if I can reproduce.
> >
>
> For larger size mmap, I think it requires enabling vm overcommit mode 1:
> echo 1 | sudo tee /proc/sys/vm/overcommit_memory

Which means the default experience isn't good.

