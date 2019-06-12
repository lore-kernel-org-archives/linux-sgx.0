Return-Path: <SRS0=wmvE=UL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94127C31E46
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 15:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ED7120874
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 15:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfFLPXn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jun 2019 11:23:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:6264 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727373AbfFLPXn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 11:23:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 08:23:42 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 12 Jun 2019 08:23:42 -0700
Date:   Wed, 12 Jun 2019 08:23:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH 7/7] x86/sgx: Add a reserved field to
 sgx_enclave_add_region to drop 'packed'
Message-ID: <20190612152341.GE20308@linux.intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-8-sean.j.christopherson@intel.com>
 <20190612151439.GA5723@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612151439.GA5723@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 12, 2019 at 06:14:39PM +0300, Jarkko Sakkinen wrote:
> On Wed, Jun 05, 2019 at 12:48:45PM -0700, Sean Christopherson wrote:
> > A reserved field could prove useful in the future, and packed structs
> > can result in inefficiencies due to its impact on alignment.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Rather should extend mrmask just to 32 bits.

I considered that option, but extending mrmask would probably confusing
to userspace, e.g. we'd have to document that bits 31:15 are ignored.
