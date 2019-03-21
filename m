Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B15C43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 16:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0187821874
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 16:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbfCUQBK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 12:01:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:16550 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfCUQBK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 12:01:10 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 09:01:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,253,1549958400"; 
   d="scan'208";a="133549592"
Received: from dilu-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.254.184])
  by fmsmga008.fm.intel.com with ESMTP; 21 Mar 2019 09:00:51 -0700
Date:   Thu, 21 Mar 2019 18:00:49 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v19 00/27] Intel SGX1 support
Message-ID: <20190321160049.GS4603@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190319234103.GM25575@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319234103.GM25575@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 19, 2019 at 04:41:03PM -0700, Sean Christopherson wrote:
> On Sun, Mar 17, 2019 at 11:14:29PM +0200, Jarkko Sakkinen wrote:
> > Intel(R) SGX is a set of CPU instructions that can be used by applications
> > to set aside private regions of code and data. The code outside the enclave
> > is disallowed to access the memory inside the enclave by the CPU access
> > control.  In a way you can think that SGX provides inverted sandbox. It
> > protects the application from a malicious host.
> > 
> > There is a new hardware unit in the processor called Memory Encryption
> > Engine (MEE) starting from the Skylake microacrhitecture. BIOS can define
> > one or many MEE regions that can hold enclave data by configuring them with
> > PRMRR registers.
> > 
> > The MEE automatically encrypts the data leaving the processor package to
> > the MEE regions. The data is encrypted using a random key whose life-time
> > is exactly one power cycle.
> > 
> > The current implementation requires that the firmware sets
> > IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
> > decide what enclaves it wants run. The implementation does not create
> > any bottlenecks to support read-only MSRs later on.
> > 
> > You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
> > 
> > 	cat /proc/cpuinfo  | grep sgx
> > 
> > v19:
> 
> ...
> 
> > * Allow the driver to be compiled as a module now that it no code is using
> >   its routines and it only uses exported symbols. Now the driver is
> >   essentially just a thin ioctl layer.
> 
> I'm not convinced it's worth the effort to allow the driver to be compiled
> as a module, especially if we drop the ACPI-based probing.  Making the
> driver loadable means the kernel can easily end up in situations where it's
> tracking EPC and running its reclaimer kthread, but the driver can't be
> loaded and can *never* be loaded, e.g. because the platform doesn't support
> Launch Control.
> 
> And IMO encl.{c,h} belongs in the "driver" code, but to let the driver be
> loadable it got shoved into the core subsystem.  All of that code is
> specific to running enclaves in the host, i.e. it shouldn't exist if I
> compile out the driver entirely (in a future world where I want the core
> SGX subsystem for virtualization purposes).
> 
> And yes, I realize this is a full 180 from my stance a year ago :)

I'm perfectly fine with removing platform driver is that is the common
opinion. I would still keep the bus (or equivalent) thought because it
gives possibility in the future add sysfs attributes.

> 
> > * Allow forking i.e. remove VM_DONTCOPY. I did not change the API
> >   because the old API scaled to the workload that Andy described. The
> >   codebase is now mostly API independent i.e. changing the API is a
> >   small task. For me the proper trigger to chanage it is a as concrete
> >   as possible workload that cannot be fulfilled. I hope you understand
> >   my thinking here. I don't want to change anything w/o proper basis
> >   but I'm ready to change anything if there is a proper basis. I do
> >   not have any kind of attachment to any particular type of API.
> 
> It's not just forking, it's being able to hand off an enclave to an
> already running process.  Andy also had (IMO) valid complaints about
> completely ignoring @filep in the ioctls() and searching the vma to
> find the enclave, e.g. the current code has to acquire mmap_sem just
> to get a reference to the enclave and a process has to mmap() the
> enclave to use any ioctl() other than ECREATE.

I'm cool with this and internals are now in a shape that is trivial
to implement. Just would want an example of workload where that
would be useful. It is not only for decision making but also
for reflecting whether the change is done correctly.

We should probably also extend the selftest to do some trivial forking
or SCM_RIGHTS kind of thing depending on the API.

/Jarkko
