Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8BAC433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 20 Dec 2021 20:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhLTUjX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 20 Dec 2021 15:39:23 -0500
Received: from mga18.intel.com ([134.134.136.126]:60195 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhLTUjW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 20 Dec 2021 15:39:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="227120318"
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="227120318"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 12:39:22 -0800
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="467536384"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.42.105])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 12:39:21 -0800
Message-ID: <9e08e13208950e9fd955a46994b7fef705751dd6.camel@linux.intel.com>
Subject: Re: [PATCH 1/2] x86/sgx: Add accounting for tracking overcommit
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Mon, 20 Dec 2021 12:39:19 -0800
In-Reply-To: <YcDZ4++GQN+ODm50@zn.tnic>
References: <20211220174640.7542-1-kristen@linux.intel.com>
         <20211220174640.7542-2-kristen@linux.intel.com> <YcDZ4++GQN+ODm50@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Boris, thanks for taking look.

On Mon, 2021-12-20 at 20:30 +0100, Borislav Petkov wrote:
> On Mon, Dec 20, 2021 at 09:46:39AM -0800, Kristen Carlson Accardi
> wrote:
> >  Similar to the core kswapd, ksgxd, is responsible for managing the
> >  overcommitment of enclave memory.  If the system runs out of
> > enclave memory,
> > -*ksgxd* “swaps” enclave memory to normal memory.
> > +*ksgxd* “swaps” enclave memory to normal RAM. This normal RAM is
> > allocated
> > +via per enclave shared memory. The shared memory area is not
> > mapped into the
> > +enclave or the task mapping it, which makes its memory use opaque
> > - including
> > +to the system out of memory killer (OOM). This can be problematic
> > when there
> > +are no limits in place on the amount an enclave can allocate.
> 
> Problematic how?

If a malicious or just extra large enclave is loaded, or even just a
lot of enclaves, it can eat up all the normal RAM on the system. Normal
methods of finding out where all the memory on the system is being
used, wouldn't be able to find this usage since it is shared memory. In
addition, the OOM killer wouldn't be able to kill any enclaves.
 
> 
> The commit message above is talking about what your patch does and
> that
> is kinda clear from the diff. The *why* is really missing. Only that
> allusion that it might be problematic in some cases but that's not
> even
> scratching the surface.
> 
> > +At boot time, the module parameter "sgx.overcommit_percent" can be
> > used to
> > +place a limit on the number of shared memory backing pages that
> > may be
> > +allocated, expressed as a percentage of the total number of EPC
> > pages in the
> > +system.  A value of 100 is the default, and represents a limit
> > equal to the
> > +number of EPC pages in the system. To disable the limit, set
> > +sgx.overcommit_percent to -1. The number of backing pages
> > available to
> > +enclaves is a global resource. If the system exceeds the number of
> > allowed
> > +backing pages in use, the reclaimer will be unable to swap EPC
> > pages to
> > +shared memory.
> 
> So you're basically putting the burden on the user/sysadmin to
> *actually* *know* what percentage is "problematic" and to know what
> to
> supply. I'd bet not very many people would know how much is
> problematic
> and it probably all depends.
> 
> So why don't you come up with a sane default, instead, which works in
> most cases and set it automatically?

The default value is set to 100%, and this percentage, plus the number
of EPC pages in the system is used to calculate a sane value for the
number of backing pages to add - in this case, exactly the number of
EPC pages in the system. It is set automatically if the parameter is
not used to override it.

> 
> Dunno, maybe some scaled percentage of memory depending on how many
> enclaves are run but all up to a sane limit of, say, 90% of total
> memory
> so that there are 10% left for normal system operation.

I think in this case you are still making a judgement call for the
admin about how much memory you think they ought to be able to use for
non-SGX operations, and it feels more natural to me to have the default
based on how many backing pages you might reasonably need. I suppose
one could check the total system memory available and double check that
the calculated number of backing pages you'd give out would never
exceed some percentage of total system RAM, but then you wind up with 2
knobs to play with instead of just one, which seems wrong to me.

> 
> This way you'll avoid "problematic" and still have some memory left
> for
> other use.
> 
> Or something like that.
> 
> Adding yet another knob is yuck and the easy way out. And we have
> waaaay
> too many knobs so we should always try to do the automatic thing, if
> at
> all possible.

I completely agree - so I'm trying to make sure I understand this
comment, as the value is currently set to default that would
automatically apply that is based on EPC memory present and not a fixed
value. So I'd like to understand what you'd like to see done
differently. are you saying you'd like to eliminated the ability to
override the automatic default? Or just that you'd rather calculate the
percentage based on total normal system RAM rather than EPC memory?

Thanks,
Kristen


