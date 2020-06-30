Return-Path: <SRS0=bD14=AL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C453C433E0
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 17:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E119920772
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 17:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593537202;
	bh=diSO1CamvrQdtfEI+H7me6fxh/KtADWecbcfO1/wVoo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=K27uoGq0x0mbRf1TysMKVWpbcvSh6YfKRW1aWtDG6WugtZyPpZHWgLzGcRJXaJevB
	 nnKKd6fDfL16kAt6kS8+LKigTx9CZbXmvq0cqGVMwKQqLBJox9rQm/gqPMnZfDbIEz
	 TJtp6IoqF5UHL58PHg80s/pV9BHC51KwBh+m7qKs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389884AbgF3RNO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729963AbgF3RNO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 30 Jun 2020 13:13:14 -0400
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 455AC207FB
        for <linux-sgx@vger.kernel.org>; Tue, 30 Jun 2020 17:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593537193;
        bh=diSO1CamvrQdtfEI+H7me6fxh/KtADWecbcfO1/wVoo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=g0VCHu5yhHihJYjJCE25aVIaqOgxXTAQluoAB712i8ttmyZBEH9ahl4xnIRcJWtkS
         iVwKR3YMRuPh4XPkXtCRNRTnWn9b1ECnWaMeQehaphzIFVerVBpEe7M17DThvkJ1sZ
         P3nA8JAbWGtM8U7nCzhsIFDigcair9/tQBjbwc0U=
Received: by mail-wm1-f46.google.com with SMTP id 17so20329375wmo.1
        for <linux-sgx@vger.kernel.org>; Tue, 30 Jun 2020 10:13:13 -0700 (PDT)
X-Gm-Message-State: AOAM532czRO513yUUmt7bKisc5bOHmwDIL4pv/y/yU+bDq20nq9tct+J
        30BkGFOIxO1a+xCcZ1FEI8Tbc8HVKhZ6fpdiXluOaw==
X-Google-Smtp-Source: ABdhPJx13kM5LtvGGzUYGYkwAaAat6ZRo22ztI1o1g0eif8uiHVa9Xl3dnH22Xl8NV08uj/0CSG98+0e/i94UHndbTI=
X-Received: by 2002:a1c:a304:: with SMTP id m4mr23802567wme.49.1593537191719;
 Tue, 30 Jun 2020 10:13:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-13-jarkko.sakkinen@linux.intel.com> <20200629160242.GB32176@zn.tnic>
 <20200629220400.GI12312@linux.intel.com> <20200630084956.GB1093@zn.tnic> <20200630142027.GA7733@linux.intel.com>
In-Reply-To: <20200630142027.GA7733@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 30 Jun 2020 10:13:00 -0700
X-Gmail-Original-Message-ID: <CALCETrVD2suWEx7ysJCpOE39Ds7-TpBaGo6KjEbq=EenaHkQ_g@mail.gmail.com>
Message-ID: <CALCETrVD2suWEx7ysJCpOE39Ds7-TpBaGo6KjEbq=EenaHkQ_g@mail.gmail.com>
Subject: Re: [PATCH v33 12/21] x86/sgx: Allow a limited use of
 ATTRIBUTE.PROVISIONKEY for attestation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, "Xing, Cedric" <cedric.xing@intel.com>,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, kmoy@google.com,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>, npmccallum@redhat.com,
        puiterwijk@redhat.com, David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 30, 2020 at 7:20 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Jun 30, 2020 at 10:49:56AM +0200, Borislav Petkov wrote:
> > On Mon, Jun 29, 2020 at 03:04:00PM -0700, Sean Christopherson wrote:
> > > /dev/sgx/provision is root-only by default, the expectation is that the admin
> > > will configure the system to grant only specific enclaves access to the
> > > PROVISION_KEY.
> >
> > Uuh, I don't like "the expectation is" - the reality happens to turn
> > differently, more often than not.
>
> Would it help if I worded it as "only root should ever be able to run an
> enclave with access to PROVISION_KEY"?  We obviously can't control what
> admins actually do, hence my wording of it as the expected behavior.
>
> > > In this series, access is fairly binary, i.e. there's no additional kernel
> > > infrastructure to help userspace make per-enclave decisions.  There have been
> > > more than a few proposals on how to extend the kernel to help provide better
> > > granularity, e.g. LSM hooks, but it was generally agreed to punt that stuff
> > > to post-upstreaming to keep things "simple" once we went far enough down
> > > various paths to ensure we weren't painting ourselves into a corner.
> >
> > So this all sounds to me like we should not upstream /dev/sgx/provision
> > now but delay it until the infrastructure for that has been made more
> > concrete. We can always add it then. Changing it after the fact -
> > if we have to and for whatever reason - would be a lot harder for a
> > user-visible interface which someone has started using already.
>
> The userspace and attestation infrastructure is very concrete, i.e. the
> need for userspace to be able to access PROVISION_KEY is there, as is the
> desire to be able to restrict access to PROVISION_KEY, e.g. I believe Andy
> Lutomirski originally requested the ability to restrict access.
>
> The additional infrastructure for per-enclave decisions is somewhat
> orthogonal to the PROVISION_KEY, e.g. they won't necessarily be employed
> by everyone running enclaves, and environments that do have per-enclave
> policies would still likely want the extra layer of restriction for
> PROVISION_KEY.  I only brought the additional policy crud to call out that
> we've done enough path-finding on additional restrictions to have strong
> confidence that adding /dev/sgx/provision won't prevent us from adding more
> fine grained control in the future.

I agree.

I anticipate that most of the nasty fine-grained stuff will end up in
userspace down the road.  Systems can be configured such that
provisioning is done as root, or systems can end up with fancy SELinux
rules or daemons that pass around fds or whatever, but all of this can
be done with the kernel code in this patchset.
