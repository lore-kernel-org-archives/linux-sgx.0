Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF78C3A5A1
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 01:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 923DC233A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 01:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732415AbfHWBeG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:34:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:64603 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732240AbfHWBeG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 21:34:06 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 18:34:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="196369056"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 22 Aug 2019 18:34:05 -0700
Date:   Thu, 22 Aug 2019 18:34:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v22 v2 8/8] x86/sgx: Pass userspace source address
 directly to EADD
Message-ID: <20190823013405.GJ25467@linux.intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
 <20190813011252.4121-9-sean.j.christopherson@intel.com>
 <74a9dbbed67ef131bf2179821ce74696120b35e1.camel@linux.intel.com>
 <20190822145049.GD25467@linux.intel.com>
 <5156a9c133e757dfcf8a8d003d39992aed6ade9a.camel@linux.intel.com>
 <20190823012516.cogaoq63kceol37u@linux.intel.com>
 <20190823012839.GI25467@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823012839.GI25467@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 22, 2019 at 06:28:39PM -0700, Sean Christopherson wrote:
> On Fri, Aug 23, 2019 at 04:25:16AM +0300, Jarkko Sakkinen wrote:
> > On Thu, Aug 22, 2019 at 08:00:15PM +0300, Jarkko Sakkinen wrote:
> > > On Thu, 2019-08-22 at 07:50 -0700, Sean Christopherson wrote:
> > > > On Thu, Aug 22, 2019 at 05:37:18PM +0300, Jarkko Sakkinen wrote:
> > > > > On Mon, 2019-08-12 at 18:12 -0700, Sean Christopherson wrote:
> > > > > > Invoke EADD with the userspace source address instead of first copying
> > > > > > the data to a kernel page to avoid the overhead of alloc_page() and
> > > > > > copy_from_user().
> > > > > > 
> > > > > > Suggested-by: Andy Lutomirski <luto@kernel.org>
> > > > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > > 
> > > > > NAK because takes away TCS validation and the commit message
> > > > > does not give any reasoning for doing that.
> > > > 
> > > > Doh, I have a thorough explanation, but apparently it never made it from
> > > > my head to the changelog.  I'll send v2 as a standalone patch.
> > > 
> > > Yeah, w/o explanation I won't just take away functionality :-)
> > 
> > I came to realize that also from security perspective it might be
> > helpful to EADD, not from a copy of the source, but from the
> > actual source.
> > 
> > So yes, I'm for not supporting copy approach at all. I think this
> > viewpoint is important to note in addition to the performance
> > perspective.
> 
> Side topic, I'm getting ELDU MAC failures on master.  Are there any known
> regressions, or should I start debugging?

Never mind, think I spotted the issue.  Hooray for git diff on branches.
