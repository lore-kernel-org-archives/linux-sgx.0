Return-Path: <SRS0=jkgx=6V=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D1FC38A2A
	for <linux-sgx@archiver.kernel.org>; Thu,  7 May 2020 19:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2821421655
	for <linux-sgx@archiver.kernel.org>; Thu,  7 May 2020 19:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgEGTfB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 7 May 2020 15:35:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:11011 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgEGTfA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 7 May 2020 15:35:00 -0400
IronPort-SDR: r97f0/4VxXD1OT8hGmUcXyapuY5qq/yyhKEHYwIeWn+9PngEo6DoyQh9NAus6R529IOWNGxjEV
 NQkIJyekvtnw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 12:34:59 -0700
IronPort-SDR: nj87xVVCE7zry7mUdncaCYSgysY1a63+8OzkZEE4Q0uofeOjWEVJL3ODM5rFaonBeBHxaA+j7/
 1yXFNmsvfY3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,364,1583222400"; 
   d="scan'208";a="264049072"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 07 May 2020 12:34:59 -0700
Date:   Thu, 7 May 2020 12:34:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
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
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200507193459.GA24519@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com>
 <20200506221422.GK3329@linux.intel.com>
 <op.0j8dm0zzwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
 <CAOASepNVckens=wiWpHj291EAo0ndi7GCVHd9j7BPn8rjy7Ykg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepNVckens=wiWpHj291EAo0ndi7GCVHd9j7BPn8rjy7Ykg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 07, 2020 at 12:49:15PM -0400, Nathaniel McCallum wrote:
> On Thu, May 7, 2020 at 1:03 AM Haitao Huang
> <haitao.huang@linux.intel.com> wrote:
> >
> > On Wed, 06 May 2020 17:14:22 -0500, Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> >
> > > On Wed, May 06, 2020 at 05:42:42PM -0400, Nathaniel McCallum wrote:
> > >> Tested on Enarx. This requires a patch[0] for v29 support.
> > >>
> > >> Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
> > >>
> > >> However, we did uncover a small usability issue. See below.
> > >>
> > >> [0]:
> > >> https://github.com/enarx/enarx/pull/507/commits/80da2352aba46aa7bc6b4d1fccf20fe1bda58662
> > >
> > > ...
> > >
> > >> > * Disallow mmap(PROT_NONE) from /dev/sgx. Any mapping (e.g.
> > >> anonymous) can
> > >> >   be used to reserve the address range. Now /dev/sgx supports only
> > >> opaque
> > >> >   mappings to the (initialized) enclave data.
> > >>
> > >> The statement "Any mapping..." isn't actually true.

Yeah, this definitely misleading.  I haven't looked at our most recent docs,
but I'm going to go out on a limb and assume we haven't documented the
preferred mechanism for carving out virtual memory for the enclave.  That
absolutely should be done.

> > >> Enarx creates a large enclave (currently 64GiB). This worked when we
> > >> created a file-backed mapping on /dev/sgx/enclave. However, switching
> > >> to an anonymous mapping fails with ENOMEM. We suspect this is because
> > >> the kernel attempts to allocate all the pages and zero them but there
> > >> is insufficient RAM available. We currently work around this by
> > >> creating a shared mapping on /dev/zero.
> > >
> > > Hmm, the kernel shouldn't actually allocate physical pages unless they're
> > > written.  I'll see if I can reproduce.
> > >
> >
> > For larger size mmap, I think it requires enabling vm overcommit mode 1:
> > echo 1 | sudo tee /proc/sys/vm/overcommit_memory

It shouldn't unless the initial mmap is "broken".  Not truly broken, but
broken in the sense that what Enarx is asking for is not actually what it
desires.
 
> Which means the default experience isn't good.

What PROT_* and MAP_* flags are passed to mmap()?  Overcommit only applies
to

	VM_WRITE (a.k.a. PROT_WRITE) && !VM_SHARED && !VM_NORESERVED

and, ignoring rlimits, VM expansion only applies to

	VM_WRITE && !VM_SHARED && !VM_STACK


So hopefully Enarx is doing something like

	base = mmap(NULL, 64gb, PROT_READ | PROT_WRITE,
		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

because that means this is effectively a userspace bug.  This goes back to
my comment about the mmap() being "broken".  Userspace is asking for a
writable, private mapping, in which case it absolutely should be accounted.

If using

	base = mmap(NULL, 64gb, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

works, then updating the SGX docs to better explain how to establish ELRANGE
is sufficient (we need to that in any case).  If the above still fails then
something else is in play.
