Return-Path: <SRS0=oZh+=WB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE11C0650F
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Aug 2019 21:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2172220C01
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Aug 2019 21:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfHEVj6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Aug 2019 17:39:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:58423 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727328AbfHEVj6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Aug 2019 17:39:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 14:39:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="176434585"
Received: from unknown (HELO localhost) ([10.252.52.83])
  by orsmga003.jf.intel.com with ESMTP; 05 Aug 2019 14:39:48 -0700
Date:   Tue, 6 Aug 2019 00:39:46 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v21 16/28] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190805213909.x5wv26zrgwqfrp4d@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-17-jarkko.sakkinen@linux.intel.com>
 <20190805161644.GD29275@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805161644.GD29275@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 05, 2019 at 09:16:44AM -0700, Sean Christopherson wrote:
> On Sat, Jul 13, 2019 at 08:07:52PM +0300, Jarkko Sakkinen wrote:
> > +static unsigned long sgx_get_unmapped_area(struct file *file,
> > +					   unsigned long addr,
> > +					   unsigned long len,
> > +					   unsigned long pgoff,
> > +					   unsigned long flags)
> > +{
> > +	if (flags & MAP_PRIVATE)
> > +		return -EINVAL;
> > +
> > +	if (flags & MAP_FIXED)
> > +		return addr;
> > +
> > +	if (len < 2 * PAGE_SIZE || len & (len - 1))
> > +		return -EINVAL;
> > +
> > +	addr = current->mm->get_unmapped_area(file, addr, 2 * len, pgoff,
> > +					      flags);
> > +	if (IS_ERR_VALUE(addr))
> > +		return addr;
> > +
> > +	addr = (addr + (len - 1)) & ~(len - 1);
> > +
> > +	return addr;
> > +}
> 
> Thinking about this more, I don't think the driver should verify or adjust
> @addr and @len during non-fixed mmap().  There is no requirement that
> userspace must map the full ELRANGE, or that an enclave's ELRANGE can
> *never* be mapped to non-EPC.  The architectural requirement is that an
> access that hits ELRANGE must map to the EPC *if* the CPU is executing the
> associated enclave.

Yeah, well, these were done in a quite different "ecosystem" where range
was the enclave and not like now. Can be considered as cruft that we
have simply missed when moving the fd associated enclaves.

In the current framework of things it definitely makes sense to remove
these calculations.

So, I guess we will end up to:

static unsigned long sgx_get_unmapped_area(struct file *file,
					   unsigned long addr,
					   unsigned long len,
					   unsigned long pgoff,
					   unsigned long flags)
{
	if (flags & MAP_PRIVATE)
		return -EINVAL;

	if (flags & MAP_FIXED)
		return addr;

	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
}

/Jarkko
