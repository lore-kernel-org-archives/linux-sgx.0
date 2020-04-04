Return-Path: <SRS0=o5ed=5U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB74CC2BA16
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 09:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7364206E9
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 09:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgDDJUe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 4 Apr 2020 05:20:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:51584 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgDDJUe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 4 Apr 2020 05:20:34 -0400
IronPort-SDR: r2ubhxum/1PH28QZWilidm2aqvUaffKDpDayNCaAHeulw+5UCmlv4rzUlXTPssen8XxjDNlBZ0
 ROpOGQLwnFPQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2020 02:20:33 -0700
IronPort-SDR: Axnjo0Vlg0pAa2yWVEYvm/yAHxYabW0uuDrz/NvsIiutC3WZDzNNLWS6NbzprXGAQPg29hthQe
 VNT/7DIW6sLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,343,1580803200"; 
   d="scan'208";a="423794597"
Received: from lbraszkx-mobl.ger.corp.intel.com (HELO localhost) ([10.252.38.75])
  by orsmga005.jf.intel.com with ESMTP; 04 Apr 2020 02:20:27 -0700
Date:   Sat, 4 Apr 2020 12:20:26 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200404092014.GA306326@linux.intel.com>
References: <20200403220848.GA7588@linux.intel.com>
 <F117745A-E01B-499E-B9E4-201C1C08258D@amacapital.net>
 <454e7252-8827-510d-65f0-f2ca60208e27@fortanix.com>
 <ea7471ff-146a-73af-903d-34552614b302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea7471ff-146a-73af-903d-34552614b302@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Apr 04, 2020 at 10:27:53AM +0300, Topi Miettinen wrote:
> On 4.4.2020 8.46, Jethro Beekman wrote:
> > This appears to originate in Debian
> > 
> > Rationale: https://salsa.debian.org/kernel-team/initramfs-tools/-/merge_requests/9
> > 
> > Interestingly, they claim mmap(/dev/zero) is special-cased? Can we do the same for SGX?
> > 
> > Some allowances were made in https://salsa.debian.org/kernel-team/initramfs-tools/-/commit/d6c6eeca3540d18f5bce95b5ffcb1823ab3050ea
> > 
> > Including those people in this conversation.
> > 
> > Ben, Towi: for context, see https://lore.kernel.org/linux-sgx/20200319142434.GA11305@linux.intel.com/T/ and https://lore.kernel.org/linux-sgx/20200401084511.GE17325@linux.intel.com/T/
> > 
> > --
> > Jethro Beekman | Fortanix
> > 
> > On 2020-04-04 05:54, Andy Lutomirski wrote:
> > > 
> > > 
> > > > On Apr 3, 2020, at 3:08 PM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> > > > 
> > > > ﻿On Fri, Apr 03, 2020 at 08:50:08AM -0700, Casey Schaufler wrote:
> > > > > > How does smackfs interact with namespaces?
> > > > > 
> > > > > Smack attributes are global. Aside from privilege issues, namespaces
> > > > > ignore and are ignored by Smack.
> > > > 
> > > > Okay.
> > > > 
> > > > For SGX, I foresee things as:
> > > > 
> > > > 1. Existing files are global.
> > > > 2. If a policy of any kind is ever added it needs to be *per container*.
> > > >    I'm not sure whether PID or user namespace is the right choice here,
> > > >    but does not matter right now as the feature is not in the queue.
> > > > 
> > > > To summarize:
> > > > 
> > > > 1. We have a heterogeneous set of files (i.e. 'enclave' and 'provision'
> > > >    are not "different sames").
> > > > 2. The files probably will have heterogeneous visibility requirements.
> > > > 
> > > > I think based on these premises own file system would be a more decent
> > > > choice than populating /dev. Beside, SGX hasn't been a driver for a
> > > > while.
> > > > 
> > > > Andy, what do you think of this?
> > > 
> > > Probably okay.  There are two semantic questions you’ll have to address, though:
> > > 
> > > - What happens if you mount sgxfs twice?  Do you get two copies that can diverge from each other, or do you get two views of the same thing?
> > > 
> > > - Can it be instantiated from outside the root initns?
> > > 
> > > It’s certainly conceptually simpler to stick with device nodes. Why exactly is Ubuntu noexecing /dev?
> > > 
> > > > 
> > > > /Jarkko
> > 
> 
> My goal is to block executing binaries directly from /dev and using the file
> descriptors from device files to avoid EXECMEM, without relying on MACs. If
> the SGX device can be used to make new executable mappings, it should honor
> noexec for /dev. Then initramfs should make a similar exception as with v86d
> and grant exec to /dev. I think sgxfs should also honor noexec but it
> probably does not make sense to mount it so.

Just to bring context: the whole sgxfs thing is something that we are
planning to do circulate the configuration issue with /dev i.e. move
device nodes as file nodes to a custom fs. That feels somewhat counter
productive and does not improve security in any possible way.

I guess we keep our stuff in /dev where it logically belongs anyway
and go through the configuration route then.

> With an ioctl to SGX device the caller can change previously writable memory
> to executable. It should be able to trigger PROCESS__EXECMEM check for
> SELinux, so perhaps LSM hook for mprotect should be called:
> https://github.com/intel/linux-sgx-driver/blob/95eaa6f6693cd86c35e10a22b4f8e483373c987c/sgx_ioctl.c#L254

You are looking at wrong thing. That is OOT driver that has diverged
from the kernel code base over four years ago.

This the latest code:

https://github.com/jsakkine-intel/linux-sgx/tree/master/arch/x86/kernel/cpu/sgx

But just look at the call pattern kselftest's main program should do:

https://github.com/jsakkine-intel/linux-sgx/blob/master/tools/testing/selftests/sgx/main.c

I.e.

1. Reserve by any means possible (usually anonymous mmap) an address
   range.
2. Construct enclave and initialize (no mapping involved).

Up until this point everything works with or without noexec.

Then:

3. mmap() regions.

Internally kernel checks for mmap() and mprotect() that address ranges
are opaque and requested permissions do not surpass the permissions that
were assigned to the enclave pages.

> Also SELinux reference policy doesn't know yet about SGX. Can the SGX
> enclave access physical memory, kernel memory or bypass MMU somehow even for
> the thread? If it can bypass SELinux protections, access should be
> conditional to boolean allow_raw_memory_access.

It can only do normal memory accesses within process address space. It
is a submode for ring-3 essentially.

SELinux policies cannot exist because the code has not reached yet
upstream. For now I think we got what we needed aka now we know that
there is a process for getting the exception and do not have to try the
customfs route.

Thank you for your feedback. Now we know what to do for the moment.

/Jarkko
