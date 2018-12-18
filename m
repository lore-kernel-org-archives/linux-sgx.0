Return-Path: <SRS0=KK61=O3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46169C43387
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 13:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E787217D9
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 13:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbeLRN1Y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Dec 2018 08:27:24 -0500
Received: from mga05.intel.com ([192.55.52.43]:45870 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbeLRN1X (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Dec 2018 08:27:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2018 05:27:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,368,1539673200"; 
   d="scan'208";a="303149375"
Received: from quwen-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.254.215])
  by fmsmga006.fm.intel.com with ESMTP; 18 Dec 2018 05:27:13 -0800
Date:   Tue, 18 Dec 2018 15:27:11 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181218132711.GD25667@linux.intel.com>
References: <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com>
 <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com>
 <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
 <20181217222047.GG12491@linux.intel.com>
 <20181218013918.GC333@linux.intel.com>
 <20181218032702.GA2903@linux.intel.com>
 <CALCETrVTfGUSfm5hy9_F00LcMUHJqAjOmfJhtXP+uD5dnmt4EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVTfGUSfm5hy9_F00LcMUHJqAjOmfJhtXP+uD5dnmt4EQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 09:02:03PM -0800, Andy Lutomirski wrote:
> That's what unmap_mapping_range(), etc do for you, no?  IOW make a
> struct address_space that represents the logical enclave address
> space, i.e. address 0 is the start and the pages count up from there.
> You can unmap pages whenever you want, and the core mm code will take
> care of zapping the pages from all vmas referencing that
> address_space.

OK, so it does. Did not have time to look at it last night (about
3AM) :-) Yes, we could use that to do the N process zapping.

Based on this discussion I can take the first steps with the swapping
code.

And yeah, I don't think we need anon inode for this one. Can just use
the dev inode (did not check in detail but on the surface looks like
it).

/Jarkko
