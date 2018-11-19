Return-Path: <SRS0=RM7e=N6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD9FC43441
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 16:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 225DE20851
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 16:19:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 225DE20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbeKTCn2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Nov 2018 21:43:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:51398 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729928AbeKTCn2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Nov 2018 21:43:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2018 08:19:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,253,1539673200"; 
   d="scan'208";a="101482710"
Received: from tmuluk-mobl4.ger.corp.intel.com (HELO localhost) ([10.249.254.135])
  by orsmga003.jf.intel.com with ESMTP; 19 Nov 2018 08:19:18 -0800
Date:   Mon, 19 Nov 2018 18:19:17 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>, andy@infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181119161917.GF13298@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 19, 2018 at 07:29:25AM -0800, Andy Lutomirski wrote:
> On Thu, Nov 15, 2018 at 5:08 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > can be used by applications to set aside private regions of code and
> > data. The code outside the enclave is disallowed to access the memory
> > inside the enclave by the CPU access control.
> >
> > SGX driver provides a ioctl API for loading and initializing enclaves.
> > Address range for enclaves is reserved with mmap() and they are
> > destroyed with munmap(). Enclave construction, measurement and
> > initialization is done with the provided the ioctl API.
> >
> 
> I brought this up a while back, and I think I should re-ask it now
> that this driver is getting close to ready:
> 
> As it stands, there's just one SGX character device, and I imagine
> that it'll be available to unprivileged applications.  I'm concerned
> that this isn't quite what we want.  I certainly think that everyone,
> or at least almost everyone, ought to be able to run normal enclaves.
> But I think that we should consider restricting who can run specially
> privileged enclaves.  In particular, the ability to run enclaves with
> the provisioning bit set is somewhat sensitive, since it effectively
> allows access to a stable fingerprint of the system.  Before flexible
> LC, this wasn't such a big deal, since only Intel's provisioning
> enclave could see the key, and Intel's enclave has some degree of
> control of what is done with the key.  With flex LC, this protection
> is lost.
> 
> But this is maybe more of a big deal than just access to a stable
> fingerprint.  The ability to provision a remote attestation protocol
> is a key part of running SGX malware, and SGX malware is surely going
> to exist some day.  (Sure, Intel will try to block access to the
> actual attestation service for malware, but I doubt that Intel will be
> able to fully defend it.)
> 
> So I propose that there be a few device nodes.  Maybe
> /dev/sgx/unprivilegd and /dev/sgx/provisioning?  The default mode of
> the latter could be 0600.  If you've opened the unprivileged node, you
> can only run enclaves without any special permission bits set.

What would the use case for unprivileged i.e. this configuration would
mean depending on permissions?

There would be three types of users:

1. Ones that have access to neither of the devices.
2. Ones that have access to unprivileged. Who are these?
3. Ones that have access to provisioning.

> We should also consider whether we allow the unprivileged node to run
> launch enclaves, and, for that matter, whether we allow user code to
> run launch enclaves at all, given that they're not useful with the
> current architecture of the driver.

ATM the launch enclave bit is disallowed by the kernel in the current
patch set. I don't really see any use case to allow them except if we
want to allow run enclaves in an environment where the MSRs are rdonly.

/Jarkko
