Return-Path: <SRS0=nADd=5B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2239DC2BB1D
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 14:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E639120724
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 14:01:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NB9rn58N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgCPOBx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:01:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41663 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729456AbgCPOBx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 16 Mar 2020 10:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584367312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aj2KXeyFDH3IYVMv4TZ9mZAZkyhD8QEE0CToBGEvBf4=;
        b=NB9rn58NThoRCnlqFgIA36qVSTUH6DasVVfTsbuyy/uO7tuZi2FwzAA8lSaalA3kTM7uSg
        4r53/y7D+8qYpLMqGO0qt7uHWpCmOVMFr3kOrCXWhUQkczqV+eflG9/C57atlJdZvVLJHY
        9vHTVdY99TBWgyK1eJARhjv2XQLPWUk=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-QPdwSyaWMeeu1-4os4sOqw-1; Mon, 16 Mar 2020 10:01:50 -0400
X-MC-Unique: QPdwSyaWMeeu1-4os4sOqw-1
Received: by mail-il1-f200.google.com with SMTP id g79so14041247ild.7
        for <linux-sgx@vger.kernel.org>; Mon, 16 Mar 2020 07:01:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aj2KXeyFDH3IYVMv4TZ9mZAZkyhD8QEE0CToBGEvBf4=;
        b=TJsZCGk8YWfYw3OoXTtLMDttR4FtWcAD/e/sUvnCpZ1OKYbzxfIkJcMdiitS8stYgR
         L7YR260TiP2fOOpXDwevbc8Wv7WgUJz5XAyJ5TigDDjfYmKAsWJbzAJai0a8qvJfTES3
         yvus8IBoCs5qvLV0JZBEW8kNrfek2jrTtmfcjI3tYgCSbL/QvceVkhMq9JvbONYlgCu/
         GYTbQEbp8WfH0yvOuvk2OiCOyrJt52Cb2w/tnu+ISPYx2TVp5HdcU4KinXXXIMfyyXRw
         G/7+nzpzIw1IjS6BvVyJ1gXj2pMFDaQYyZP78ZNn/9SZOJEIfUbiOZNdE1LWe6d3EDl6
         SNHA==
X-Gm-Message-State: ANhLgQ13W+r9XHITRiN4BD0vwtVBpwBfrw2ddcOuBQmUcLrrFEtQqZeG
        3wHMbwF3Tpg+D4DrvnQECY1VokWZ5DTqMBbAOzCLvIyg6xNWT1wwWR8RVpbQiTwN/eGFm6ZEqV7
        3pTjwLFMlD+ll1EgZqmUSy3yFmmxppfVCoMtC
X-Received: by 2002:a92:41c7:: with SMTP id o190mr26917565ila.11.1584367309968;
        Mon, 16 Mar 2020 07:01:49 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvXN5mRtIF4p9gJ819bqSH04fLnfqGl/DkjD/ngzkHsCN4/wjuHbh30m5R1fHHGF5GB2Yag+lg/1nzJ0Til9jA=
X-Received: by 2002:a92:41c7:: with SMTP id o190mr26917528ila.11.1584367309610;
 Mon, 16 Mar 2020 07:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <20200315012523.GC208715@linux.intel.com> <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
 <94ce05323c4de721c4a6347223885f2ad9f541af.camel@linux.intel.com>
In-Reply-To: <94ce05323c4de721c4a6347223885f2ad9f541af.camel@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Mon, 16 Mar 2020 10:01:38 -0400
Message-ID: <CAOASepM1pp1emPwSdFcaRkZfFm6sNmwPCJH+iFMiaJpFjU0VxQ@mail.gmail.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        cedric.xing@intel.com, Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 16, 2020 at 9:56 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Sun, 2020-03-15 at 13:53 -0400, Nathaniel McCallum wrote:
> > On Sat, Mar 14, 2020 at 9:25 PM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > > On Wed, Mar 11, 2020 at 01:30:07PM -0400, Nathaniel McCallum wrote:
> > > > Currently, the selftest has a wrapper around
> > > > __vdso_sgx_enter_enclave() which preserves all x86-64 ABI callee-saved
> > > > registers (CSRs), though it uses none of them. Then it calls this
> > > > function which uses %rbx but preserves none of the CSRs. Then it jumps
> > > > into an enclave which zeroes all these registers before returning.
> > > > Thus:
> > > >
> > > >   1. wrapper saves all CSRs
> > > >   2. wrapper repositions stack arguments
> > > >   3. __vdso_sgx_enter_enclave() modifies, but does not save %rbx
> > > >   4. selftest zeros all CSRs
> > > >   5. wrapper loads all CSRs
> > > >
> > > > I'd like to propose instead that the enclave be responsible for saving
> > > > and restoring CSRs. So instead of the above we have:
> > > >   1. __vdso_sgx_enter_enclave() saves %rbx
> > > >   2. enclave saves CSRs
> > > >   3. enclave loads CSRs
> > > >   4. __vdso_sgx_enter_enclave() loads %rbx
> > > >
> > > > I know that lots of other stuff happens during enclave transitions,
> > > > but at the very least we could reduce the number of instructions
> > > > through this critical path.
> > >
> > > What Jethro said and also that it is a good general principle to cut
> > > down the semantics of any vdso as minimal as possible.
> > >
> > > I.e. even if saving RBX would make somehow sense it *can* be left
> > > out without loss in terms of what can be done with the vDSO.
> >
> > Please read the rest of the thread. Sean and I have hammered out some
> > sensible and effective changes.
>
> Have skimmed through that discussion but it comes down how much you get
> by obviously degrading some of the robustness. Complexity of the calling
> pattern is not something that should be emphasized as that is something
> that is anyway hidden inside the runtime.

My suggestions explicitly maintained robustness, and in fact increased
it. If you think we've lost capability, please speak with specificity
rather than in vague generalities. Under my suggestions we can:
1. call the vDSO from C
2. pass context to the handler
3. have additional stack manipulation options in the handler

The cost for this is a net 2 additional instructions. No existing
capability is lost.

