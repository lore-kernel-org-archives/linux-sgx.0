Return-Path: <SRS0=OlKO=UP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8996C31E50
	for <linux-sgx@archiver.kernel.org>; Sun, 16 Jun 2019 22:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 732ED2084B
	for <linux-sgx@archiver.kernel.org>; Sun, 16 Jun 2019 22:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560723310;
	bh=T8BMYPj/+axcxNZqcbu8ibBvh7s2DD0/VdD4zxhxLeA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=euVZ6Z7U2YyPOmMUJ1+AJJ5oO40elM5iI/04C64Iy3/6yyWvyDnkdu+ycmgpS6D/v
	 8x5i5pz0dSV3PpC64Xq4yDH18drujMAchrFrtre7c+Nv+BaQRoBS2TdCpMrA2R60M8
	 zPUUvyAdXIks3OXAjtCVPlMd7BrpplxKSDgjqaLo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfFPWPG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 16 Jun 2019 18:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbfFPWPG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 16 Jun 2019 18:15:06 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C51D42182B
        for <linux-sgx@vger.kernel.org>; Sun, 16 Jun 2019 22:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560723305;
        bh=T8BMYPj/+axcxNZqcbu8ibBvh7s2DD0/VdD4zxhxLeA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=d+h/h0q/s84bUBwAaM1Y83/yBNoRIFSlObpvPZaNqwFfLYUmKGansy4ed7o8RvB6Q
         aDR02dcVCIF3fyrSAnddLz3Dp9GgtbWTjIA4uYEk715kzZR8pFzndL4h3ju6zWPtjs
         9HdKQCGr5Xmae+fAdHuhAqie7WuyUNklCTF6zHis=
Received: by mail-wm1-f51.google.com with SMTP id z23so7098349wma.4
        for <linux-sgx@vger.kernel.org>; Sun, 16 Jun 2019 15:15:04 -0700 (PDT)
X-Gm-Message-State: APjAAAVGzJmHPcsut7ZOuOBaK40GHdfklmg17iizmT+llx/3iIZn82s6
        uBv4x1SrGhmQVya5QthJT36oVM4VlQbC6nivSrXrlw==
X-Google-Smtp-Source: APXvYqwpSi3Fvd1ZlarCdUyN4jh9ApzomVyJAYqFA2ni2ET5eOuE3o1HHfRDX91kVa0cYCWwGOFdDzsAbE0gRf4xA4k=
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr16244320wmj.79.1560723303094;
 Sun, 16 Jun 2019 15:15:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560131039.git.cedric.xing@intel.com> <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov> <20190611220243.GB3416@linux.intel.com>
 <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov> <20190614004600.GF18385@linux.intel.com>
 <20190614153840.GC12191@linux.intel.com>
In-Reply-To: <20190614153840.GC12191@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 16 Jun 2019 15:14:51 -0700
X-Gmail-Original-Message-ID: <CALCETrXcOQkvMHdh5DgdQ6JAgzsZCNFVEtnQz-5RbNr4vsadDQ@mail.gmail.com>
Message-ID: <CALCETrXcOQkvMHdh5DgdQ6JAgzsZCNFVEtnQz-5RbNr4vsadDQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in SELinux
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Cedric Xing <cedric.xing@intel.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-sgx@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        pmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 14, 2019 at 8:38 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Jun 13, 2019 at 05:46:00PM -0700, Sean Christopherson wrote:
> > On Thu, Jun 13, 2019 at 01:02:17PM -0400, Stephen Smalley wrote:
> > > On 6/11/19 6:02 PM, Sean Christopherson wrote:
> > > >On Tue, Jun 11, 2019 at 09:40:25AM -0400, Stephen Smalley wrote:
> > > >>I haven't looked at this code closely, but it feels like a lot of
> > > >>SGX-specific logic embedded into SELinux that will have to be repeated or
> > > >>reused for every security module.  Does SGX not track this state itself?
> > > >
> > > >SGX does track equivalent state.
> > > >
> > > >There are three proposals on the table (I think):
> > > >
> > > >   1. Require userspace to explicitly specificy (maximal) enclave page
> > > >      permissions at build time.  The enclave page permissions are provided
> > > >      to, and checked by, LSMs at enclave build time.
> > > >
> > > >      Pros: Low-complexity kernel implementation, straightforward auditing
> > > >      Cons: Sullies the SGX UAPI to some extent, may increase complexity of
> > > >            SGX2 enclave loaders.
> > > >
> > > >   2. Pre-check LSM permissions and dynamically track mappings to enclave
> > > >      pages, e.g. add an SGX mprotect() hook to restrict W->X and WX
> > > >      based on the pre-checked permissions.
> > > >
> > > >      Pros: Does not impact SGX UAPI, medium kernel complexity
> > > >      Cons: Auditing is complex/weird, requires taking enclave-specific
> > > >            lock during mprotect() to query/update tracking.
> > > >
> > > >   3. Implement LSM hooks in SGX to allow LSMs to track enclave regions
> > > >      from cradle to grave, but otherwise defer everything to LSMs.
> > > >
> > > >      Pros: Does not impact SGX UAPI, maximum flexibility, precise auditing
> > > >      Cons: Most complex and "heaviest" kernel implementation of the three,
> > > >            pushes more SGX details into LSMs.
> > > >
> > > >My RFC series[1] implements #1.  My understanding is that Andy (Lutomirski)
> > > >prefers #2.  Cedric's RFC series implements #3.
> > > >
> > > >Perhaps the easiest way to make forward progress is to rule out the
> > > >options we absolutely *don't* want by focusing on the potentially blocking
> > > >issue with each option:
> > > >
> > > >   #1 - SGX UAPI funkiness
> > > >
> > > >   #2 - Auditing complexity, potential enclave lock contention
> > > >
> > > >   #3 - Pushing SGX details into LSMs and complexity of kernel implementation
> > > >
> > > >
> > > >[1] https://lkml.kernel.org/r/20190606021145.12604-1-sean.j.christopherson@intel.com
> > >
> > > Given the complexity tradeoff, what is the clear motivating example for why
> > > #1 isn't the obvious choice? That the enclave loader has no way of knowing a
> > > priori whether the enclave will require W->X or WX?  But aren't we better
> > > off requiring enclaves to be explicitly marked as needing such so that we
> > > can make a more informed decision about whether to load them in the first
> > > place?
> >
> > Andy and/or Cedric, can you please weigh in with a concrete (and practical)
> > use case that will break if we go with #1?  The auditing issues for #2/#3
> > are complex to say the least...

The most significant issue I see is the following.  Consider two
cases. First, an SGX2 enclave that dynamically allocates memory but
doesn't execute code from dynamic memory.  Second, an SGX2 enclave
that *does* execute code from dynamic memory.  In #1, the untrusted
stack needs to decide whether to ALLOW_EXEC when the memory is
allocated, which means that it either needs to assume the worst or it
needs to know at allocation time whether the enclave ever intends to
change the permission to X.

I suppose there's a middle ground.  The driver could use model #1 for
driver-filled pages and model #2 for dynamic pages.  I haven't tried
to fully work it out, but I think there would be the ALLOW_READ /
ALLOW_WRITE / ALLOW_EXEC flag for EADD-ed pages but, for EAUG-ed
pages, there would be a different policy.  This might be as simple as
internally having four flags instead of three:

ALLOW_READ, ALLOW_WRITE, ALLOW_EXEC: as before

ALLOW_EXEC_COND: set implicitly by the driver for EAUG.

As in #1, if you try to mmap or protect a page with neither ALLOW_EXEC
variant, it fails (-EACCES, perhaps).  But, if you try to mmap or
mprotect an ALLOW_EXEC_COND page with PROT_EXEC, you ask LSM for
permission.  There is no fancy DIRTY tracking here, since it's
reasonable to just act as though *every* ALLOW_EXEC_COND page is
dirty.  There is no real auditing issue here, since LSM can just log
what permission is missing.

Does this seem sensible?  It might give us the best of #1 and #2.

>
> Follow-up question, is #1 any more palatable if SELinux adds SGX specific
> permissions and ties them to the process (instead of the vma or sigstruct)?

I'm not sure this makes a difference.  It simplifies SIGSTRUCT
handling, which is handy.
