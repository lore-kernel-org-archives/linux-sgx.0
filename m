Return-Path: <SRS0=tPzl=NT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EF3ECDE47
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 14:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93C1F2081D
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 14:46:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93C1F2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbeKIAWT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:22:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:26519 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbeKIAWT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Nov 2018 19:22:19 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2018 06:46:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,480,1534834800"; 
   d="scan'208";a="272425237"
Received: from ibanaga-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.75])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2018 06:46:04 -0800
Date:   Thu, 8 Nov 2018 16:46:03 +0200
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
Message-ID: <20181108144603.GA14072@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
 <20181106134758.10572-19-jarkko.sakkinen@linux.intel.com>
 <1541522400.7839.48.camel@intel.com>
 <20181107163757.GB11509@linux.intel.com>
 <20181107180057.GB24807@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107180057.GB24807@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 07, 2018 at 10:00:57AM -0800, Sean Christopherson wrote:
> What do we gain by a single buffer vs. separate buffers?  The ioctl()
> would be slightly smaller but it seems like the actual code would be
> more complex.

I'm fine with either. It was just a suggestion.

> The enclave build process also utilizes the backing as temp storage
> to avoid having to alloc kernel memory when queueing pages to be added
> by the worker thread (which reminds me that I wanted to document why a
> worker thread is used).  Keeping this behavior would effectively make
> providing backing mandatory.

Would it be a problem just allocate those pages with alloc_page() and
free them in the worker thread?

> Are there any potential complications with ENCLS consuming userspace
> pointers?  We'd have to wrap them with user_access_{begin,end}() and
> probably tweak the fixup, but I assume having the fixup handler means
> we're generally ok?

Last time I did it I used get_user_pages() for pinning. I'm not sure
why I should do anything but just re-use that.

/Jarkko
