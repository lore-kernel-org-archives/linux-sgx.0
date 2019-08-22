Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268FCC3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 17:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED5F3233FE
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 17:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbfHVRA1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 13:00:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:46146 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729052AbfHVRA1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 13:00:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 10:00:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="208241113"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by fmsmga002.fm.intel.com with ESMTP; 22 Aug 2019 10:00:23 -0700
Message-ID: <5156a9c133e757dfcf8a8d003d39992aed6ade9a.camel@linux.intel.com>
Subject: Re: [PATCH for_v22 v2 8/8] x86/sgx: Pass userspace source address
 directly to EADD
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Date:   Thu, 22 Aug 2019 20:00:15 +0300
In-Reply-To: <20190822145049.GD25467@linux.intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
         <20190813011252.4121-9-sean.j.christopherson@intel.com>
         <74a9dbbed67ef131bf2179821ce74696120b35e1.camel@linux.intel.com>
         <20190822145049.GD25467@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2019-08-22 at 07:50 -0700, Sean Christopherson wrote:
> On Thu, Aug 22, 2019 at 05:37:18PM +0300, Jarkko Sakkinen wrote:
> > On Mon, 2019-08-12 at 18:12 -0700, Sean Christopherson wrote:
> > > Invoke EADD with the userspace source address instead of first copying
> > > the data to a kernel page to avoid the overhead of alloc_page() and
> > > copy_from_user().
> > > 
> > > Suggested-by: Andy Lutomirski <luto@kernel.org>
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > NAK because takes away TCS validation and the commit message
> > does not give any reasoning for doing that.
> 
> Doh, I have a thorough explanation, but apparently it never made it from
> my head to the changelog.  I'll send v2 as a standalone patch.

Yeah, w/o explanation I won't just take away functionality :-)

/Jarkko

