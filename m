Return-Path: <SRS0=ssez=NS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F28C0044C
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Nov 2018 16:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 906A72086C
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Nov 2018 16:38:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 906A72086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbeKHCJP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Nov 2018 21:09:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:53472 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbeKHCJP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Nov 2018 21:09:15 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2018 08:38:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,476,1534834800"; 
   d="scan'208";a="84068375"
Received: from kaczmarx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.132])
  by fmsmga007.fm.intel.com with ESMTP; 07 Nov 2018 08:37:59 -0800
Date:   Wed, 7 Nov 2018 18:37:57 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v16 18/22] platform/x86: Intel SGX driver
Message-ID: <20181107163757.GB11509@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
 <20181106134758.10572-19-jarkko.sakkinen@linux.intel.com>
 <1541522400.7839.48.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1541522400.7839.48.camel@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 06, 2018 at 08:40:00AM -0800, Sean Christopherson wrote:
> On Tue, 2018-11-06 at 15:45 +0200, Jarkko Sakkinen wrote:
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > can be used by applications to set aside private regions of code and
> > data. The code outside the enclave is disallowed to access the memory
> > inside the enclave by the CPU access control.
> > 
> > SGX driver provides a ioctl API for loading and initializing enclaves.
> > Address range for enclaves is reserved with mmap() and they are
> > destroyed with munmap(). Enclave construction, measurement and
> > initialization is done with the provided the ioctl API.
> 
> ...
> 
> > +struct sgx_encl {
> > +	unsigned int flags;
> > +	uint64_t attributes;
> > +	uint64_t xfrm;
> > +	unsigned int page_cnt;
> > +	unsigned int secs_child_cnt;
> > +	struct mutex lock;
> > +	struct mm_struct *mm;
> > +	struct file *backing;
> 
> Is there any particular reason why the kernel manages the backing for
> the enclave and the PCMDs?  Could we have userspace provide the backing
> either through the ECREATE ioctl() or maybe a completely new ioctl(),
> e.g. to give userspace the option to back the enclave with a NVDIMM
> instead of RAM?  A separate ioctl() with control flags might give us
> some flexibility in the future, e.g. maybe there are use cases where
> userspace would prefer to kill enclaves rather than swap EPC.

Not really except that no one has complained. The very first swapping
code that I implemented used a VMA as backing storage. I could take
pieces of that code to replace shmem specifics. The difference was that
the driver did vm_mmap(). Now that you suggested the above I wonder how
it did not came to mind back then to provide the VMA as parameter.

A single buffer that can hold both PCMD entries and swapped pages in its
address space would probably be the  best way to do it. I would add that
as a field to struct sgx_enclave_create. If we want the kill-behavior,
you could signal that with a NULL value.

/Jarkko
