Return-Path: <SRS0=HOZE=O4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF76C43387
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 05:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB7A521871
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 05:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725294AbeLSFA5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Dec 2018 00:00:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:38149 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbeLSFA5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Dec 2018 00:00:57 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2018 21:00:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,371,1539673200"; 
   d="scan'208";a="119450894"
Received: from cqinghon-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.254.218])
  by orsmga002.jf.intel.com with ESMTP; 18 Dec 2018 21:00:48 -0800
Date:   Wed, 19 Dec 2018 07:00:47 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181219050047.GC14295@linux.intel.com>
References: <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com>
 <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com>
 <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
 <20181217222047.GG12491@linux.intel.com>
 <CALCETrX1HXZvMk8UM6wV5StTj+vvqehAvybJYk66At60t91QGQ@mail.gmail.com>
 <20181218154417.GC28326@linux.intel.com>
 <20181218185349.GC30082@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218185349.GC30082@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 18, 2018 at 10:53:49AM -0800, Sean Christopherson wrote:
> What if we re-organize the ioctls in such a way that we leave open the
> possibility of allocating raw EPC for KVM via /dev/sgx?  I'm not 100%
> positive this approach will work[1], but conceptually it fits well with
> KVM's memory model, e.g. KVM is aware of the GPA<->HVA association but
> generally speaking doesn't know what's physically backing each memory
> region.

Why would you want to pass EPC through user space to KVM rather than
KVM allocating it through kernel interfaces?

> Tangentially related, I think we should support allocating multiple
> enclaves from a single /dev/sgx fd, i.e. a process shouldn't have to
> open /dev/sgx every time it wants to create a new enclave.

I'm fine with this. It just requires to create anon inode. I'll just
add a new field called 'enclave_fd' to struct sgx_enclave_create and
that's all.

I think I have otherwise ingredients for v19 ready except where to swap.

/Jarkko
