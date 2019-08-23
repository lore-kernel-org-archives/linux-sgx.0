Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BBCC3A5A1
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 01:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B4D3233A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 01:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387995AbfHWBZV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:25:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:24873 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfHWBZV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 21:25:21 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 18:25:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="184069830"
Received: from nmordaws-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.38.129])
  by orsmga006.jf.intel.com with ESMTP; 22 Aug 2019 18:25:17 -0700
Date:   Fri, 23 Aug 2019 04:25:16 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v22 v2 8/8] x86/sgx: Pass userspace source address
 directly to EADD
Message-ID: <20190823012516.cogaoq63kceol37u@linux.intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
 <20190813011252.4121-9-sean.j.christopherson@intel.com>
 <74a9dbbed67ef131bf2179821ce74696120b35e1.camel@linux.intel.com>
 <20190822145049.GD25467@linux.intel.com>
 <5156a9c133e757dfcf8a8d003d39992aed6ade9a.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5156a9c133e757dfcf8a8d003d39992aed6ade9a.camel@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 22, 2019 at 08:00:15PM +0300, Jarkko Sakkinen wrote:
> On Thu, 2019-08-22 at 07:50 -0700, Sean Christopherson wrote:
> > On Thu, Aug 22, 2019 at 05:37:18PM +0300, Jarkko Sakkinen wrote:
> > > On Mon, 2019-08-12 at 18:12 -0700, Sean Christopherson wrote:
> > > > Invoke EADD with the userspace source address instead of first copying
> > > > the data to a kernel page to avoid the overhead of alloc_page() and
> > > > copy_from_user().
> > > > 
> > > > Suggested-by: Andy Lutomirski <luto@kernel.org>
> > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > NAK because takes away TCS validation and the commit message
> > > does not give any reasoning for doing that.
> > 
> > Doh, I have a thorough explanation, but apparently it never made it from
> > my head to the changelog.  I'll send v2 as a standalone patch.
> 
> Yeah, w/o explanation I won't just take away functionality :-)

I came to realize that also from security perspective it might be
helpful to EADD, not from a copy of the source, but from the
actual source.

So yes, I'm for not supporting copy approach at all. I think this
viewpoint is important to note in addition to the performance
perspective.

/Jarkko
