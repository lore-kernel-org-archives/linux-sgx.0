Return-Path: <SRS0=OlKO=UP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67556C31E50
	for <linux-sgx@archiver.kernel.org>; Sun, 16 Jun 2019 22:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1555220866
	for <linux-sgx@archiver.kernel.org>; Sun, 16 Jun 2019 22:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560723408;
	bh=oLx5pniqxG/jELRH2iyGmtPEYVhozT1h6R4yt+A9/zc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=MjQOP+d0JgfgJa2ISBaQHCM/JLo2nBnRkpDciLVlP7Y+Sya4fiM+lY+8z5WIt93F3
	 /AOoEBuG1VbbfmATcC/+8rn9wENYOJb7rE9gVaj7OCyxJxE96K1POEkmkpRo7Nevn4
	 sukwUqyYX9Q5vclRdAK/xllnvggEV79EmEnh7nEs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfFPWQr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 16 Jun 2019 18:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbfFPWQr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 16 Jun 2019 18:16:47 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1A91217D4
        for <linux-sgx@vger.kernel.org>; Sun, 16 Jun 2019 22:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560723406;
        bh=oLx5pniqxG/jELRH2iyGmtPEYVhozT1h6R4yt+A9/zc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=T+y0s0KCYKjJALEZNyPoXM5/rZcyVy81hMNXsvjs1JoQof8fTSG2t6O2B7gnYh6KE
         Ut3jaYPJDUcKaTX1rbCTyjBJQzV6v1GsdVNZFCMI6jwt1PJAwgesmrRBSXBw8W+XGl
         JQp8pKioMJXgvb/P4BcsGhh4AEUfQXu3hbDQGi98=
Received: by mail-wm1-f43.google.com with SMTP id c66so7299699wmf.0
        for <linux-sgx@vger.kernel.org>; Sun, 16 Jun 2019 15:16:45 -0700 (PDT)
X-Gm-Message-State: APjAAAUYikBf2Yy6KvUij3hAbPUEYm6jJcS2OQAYm1562PBgr3ts/MFP
        wFBcIipvgFmNtIG1QQz5qsw/FXA27nA/c4UF/f94Cw==
X-Google-Smtp-Source: APXvYqyLNC6Yg329xWtpRh6aEChlgRxAAqzoyltmGU+X5FI8weBu+KOZvAoY8R4ojMAgdUlfKbzzFc86TSOLGIg1qZA=
X-Received: by 2002:a1c:9a53:: with SMTP id c80mr15207022wme.173.1560723404414;
 Sun, 16 Jun 2019 15:16:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560131039.git.cedric.xing@intel.com> <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov> <20190611220243.GB3416@linux.intel.com>
 <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov> <20190614004600.GF18385@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F65504665@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F65504665@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 16 Jun 2019 15:16:32 -0700
X-Gmail-Original-Message-ID: <CALCETrUaNCmO9Ne38ifnkfKTaZttTYCXPpLuHfR_NaGUwBNdSQ@mail.gmail.com>
Message-ID: <CALCETrUaNCmO9Ne38ifnkfKTaZttTYCXPpLuHfR_NaGUwBNdSQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in SELinux
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "pmccallum@redhat.com" <pmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 14, 2019 at 10:16 AM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> > From: Christopherson, Sean J
> > Sent: Thursday, June 13, 2019 5:46 PM
> >
> > On Thu, Jun 13, 2019 at 01:02:17PM -0400, Stephen Smalley wrote:
> > > On 6/11/19 6:02 PM, Sean Christopherson wrote:
> > > >On Tue, Jun 11, 2019 at 09:40:25AM -0400, Stephen Smalley wrote:
> > > >>I haven't looked at this code closely, but it feels like a lot of
> > > >>SGX-specific logic embedded into SELinux that will have to be
> > > >>repeated or reused for every security module.  Does SGX not track
> > this state itself?
> > > >
> > > >SGX does track equivalent state.
> > > >
> > > >There are three proposals on the table (I think):
> > > >
> > > >   1. Require userspace to explicitly specificy (maximal) enclave
> > page
> > > >      permissions at build time.  The enclave page permissions are
> > provided
> > > >      to, and checked by, LSMs at enclave build time.
> > > >
> > > >      Pros: Low-complexity kernel implementation, straightforward
> > auditing
> > > >      Cons: Sullies the SGX UAPI to some extent, may increase
> > complexity of
> > > >            SGX2 enclave loaders.
> > > >
> > > >   2. Pre-check LSM permissions and dynamically track mappings to
> > enclave
> > > >      pages, e.g. add an SGX mprotect() hook to restrict W->X and WX
> > > >      based on the pre-checked permissions.
> > > >
> > > >      Pros: Does not impact SGX UAPI, medium kernel complexity
> > > >      Cons: Auditing is complex/weird, requires taking enclave-
> > specific
> > > >            lock during mprotect() to query/update tracking.
> > > >
> > > >   3. Implement LSM hooks in SGX to allow LSMs to track enclave
> > regions
> > > >      from cradle to grave, but otherwise defer everything to LSMs.
> > > >
> > > >      Pros: Does not impact SGX UAPI, maximum flexibility, precise
> > auditing
> > > >      Cons: Most complex and "heaviest" kernel implementation of the
> > three,
> > > >            pushes more SGX details into LSMs.
> > > >
> > > >My RFC series[1] implements #1.  My understanding is that Andy
> > > >(Lutomirski) prefers #2.  Cedric's RFC series implements #3.
> > > >
> > > >Perhaps the easiest way to make forward progress is to rule out the
> > > >options we absolutely *don't* want by focusing on the potentially
> > > >blocking issue with each option:
> > > >
> > > >   #1 - SGX UAPI funkiness
> > > >
> > > >   #2 - Auditing complexity, potential enclave lock contention
> > > >
> > > >   #3 - Pushing SGX details into LSMs and complexity of kernel
> > > > implementation
> > > >
> > > >
> > > >[1]
> > > >https://lkml.kernel.org/r/20190606021145.12604-1-sean.j.christopherso
> > > >n@intel.com
> > >
> > > Given the complexity tradeoff, what is the clear motivating example
> > > for why
> > > #1 isn't the obvious choice? That the enclave loader has no way of
> > > knowing a priori whether the enclave will require W->X or WX?  But
> > > aren't we better off requiring enclaves to be explicitly marked as
> > > needing such so that we can make a more informed decision about
> > > whether to load them in the first place?
> >
> > Andy and/or Cedric, can you please weigh in with a concrete (and
> > practical) use case that will break if we go with #1?  The auditing
> > issues for #2/#3 are complex to say the least...
>
> How does enclave loader provide per-page ALLOW_* flags? And a related question is why they are necessary for enclaves but unnecessary for regular executables or shared objects.
>
> What's the story for SGX2 if mmap()'ing non-existing pages is not allowed?
>

I think it just works.  Either you can't mmap() the page until you
have explicitly EAUG-ed it, or you add a new ioctl() that is
effectively "EAUG lazily".  The latter would declare that address and
request that it get allocated and EAUGed when faulted, but it wouldn't
actually do the EAUG.

--Andy
