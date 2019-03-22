Return-Path: <SRS0=8iz8=RZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9539C43381
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 18:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 987392192C
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 18:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553278845;
	bh=1kWctT+kE5evAeNibbLsh26YhCyp/R9wPRN6xPGJ6RQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=PHDK35/MwVaLSGTqt2m4v28GwphLlL9JPkOlCWMthRKCsHha7RKruyLIw6fDW5CeV
	 rMvKIlMAZ1EAnfr10RhY9o+oEa6XONECfRDR475HPaNPdX7J1BuDP/Rv31jsqRTI9Z
	 meM7iiDki76kYtNiIxe+TxGnkYE0w3KsDSZQ9iyE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfCVSUp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Mar 2019 14:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbfCVSUp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Mar 2019 14:20:45 -0400
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DC792195D
        for <linux-sgx@vger.kernel.org>; Fri, 22 Mar 2019 18:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553278843;
        bh=1kWctT+kE5evAeNibbLsh26YhCyp/R9wPRN6xPGJ6RQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0yqXIugVnq1peMz8GRbz5OTwbgKFr/s/0O4w0jeHkX4qnmus0svKwUMoMnEdhkLyP
         SOwDdI0yCUEMX7BNgMjS1u3Xrt8jNFhxMZle2pbvo/LhpmRqJRtzMl19DqqUgtHSdj
         JA0KYWLZS31elmhZtVH6bbGVrF4CdZL7K6w2UCNw=
Received: by mail-wm1-f44.google.com with SMTP id v14so3099153wmf.2
        for <linux-sgx@vger.kernel.org>; Fri, 22 Mar 2019 11:20:43 -0700 (PDT)
X-Gm-Message-State: APjAAAWA6K1TiX8j2oIXw/tK4/MHGs1AFYqZZbTIST0+5QYzsgJkxAHt
        uKJGVs4XCwDfLP6FtUDgumHXvSvG9Vf/FJ7h9YJVbw==
X-Google-Smtp-Source: APXvYqy2I1uslvP3FiFGfyDUKj1iCdva2ck5rAWUz5OQB/IcpxoXuOmb1NCFUiPP6ho3FC3uGpp9/Zjux5Wvmv22uow=
X-Received: by 2002:a7b:c257:: with SMTP id b23mr3828467wmj.83.1553278841796;
 Fri, 22 Mar 2019 11:20:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com> <CALCETrXQ0x2TD5GnaHhmF6SExk0C8+L0AwfnH-Krqwttfvwz2A@mail.gmail.com>
 <20190322112938.GJ3122@linux.intel.com> <20190322114325.GA10165@linux.intel.com>
In-Reply-To: <20190322114325.GA10165@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 22 Mar 2019 11:20:30 -0700
X-Gmail-Original-Message-ID: <CALCETrW=Fr8EdVq+5FLbmdL__i82FC0ONHd=hBXjxpLcsv9M0Q@mail.gmail.com>
Message-ID: <CALCETrW=Fr8EdVq+5FLbmdL__i82FC0ONHd=hBXjxpLcsv9M0Q@mail.gmail.com>
Subject: Re: [PATCH v19 17/27] x86/sgx: Add provisioning
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 22, 2019 at 4:43 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Fri, Mar 22, 2019 at 01:29:38PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Mar 21, 2019 at 09:50:41AM -0700, Andy Lutomirski wrote:
> > > On Sun, Mar 17, 2019 at 2:18 PM Jarkko Sakkinen
> > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > >
> > > > In order to provide a mechanism for devilering provisoning rights:
> > > >
> > > > 1. Add a new file to the securityfs file called sgx/provision that works
> > > >    as a token for allowing an enclave to have the provisioning privileges.
> > > > 2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that accepts the
> > > >    following data structure:
> > > >
> > > >    struct sgx_enclave_set_attribute {
> > > >            __u64 addr;
> > > >            __u64 token_fd;
> > > >    };
> > >
> > > Here's a potential issue:
> > >
> > > For container use, is it reasonable for a container manager to
> > > bind-mount a file into securityfs?  Or would something in /dev make
> > > this easier?
> >
> > I guess that is a valid point given that the securityfs contains the LSM
> > (e.g. SELinux or AppArmor) policy. So yeah, I think your are right what
> > you say.
> >
> > I propose that we create /dev/sgx/enclave to act as the enclave manager
> > and /dev/sgx/provision for provisioning. Is this sustainable for you?
>
> Hmm.. on 2nd thought the LSM policy or even DAC policy  would restrict
> that the container manager can only access specific files inside
> securityfs. With this conclusion I still think it is probably the best
> place for seurity policy like things even for SGX. It is meant for that
> anyway.
>

LSM or DAC policy can certainly *restrict* it, but I suspect that most
container runtimes don't mount securityfs at all.  OTOH, the runtime
definitely needs to have a way to pass /dev/sgx/enclave (or whatever
it's called) through, so using another device node will definitely
work.
