Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689AFC31E49
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 13:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34666206E0
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 13:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfFSNYT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 09:24:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:5445 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfFSNYS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 09:24:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 06:24:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="170560736"
Received: from stephanf-mobl2.ger.corp.intel.com ([10.252.34.117])
  by orsmga002.jf.intel.com with ESMTP; 19 Jun 2019 06:24:15 -0700
Message-ID: <4a6512f4dff6036c4f66c1f27ce820308d5839ef.camel@linux.intel.com>
Subject: Re: [PATCH RFC] x86/sgx: Do not increase encl->refcount for VMAs
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, luto@kernel.org, cedric.xing@intel.com
In-Reply-To: <20190617165224.GB25085@linux.intel.com>
References: <20190613163008.4060-1-jarkko.sakkinen@linux.intel.com>
         <20190617164025.GA9762@linux.intel.com>
         <20190617165224.GB25085@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160
 Espoo
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Wed, 19 Jun 2019 15:46:38 +0300
User-Agent: Evolution 3.32.1-2 
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2019-06-17 at 09:52 -0700, Sean Christopherson wrote:
> On Mon, Jun 17, 2019 at 07:40:25PM +0300, Jarkko Sakkinen wrote:
> > On Thu, Jun 13, 2019 at 07:30:07PM +0300, Jarkko Sakkinen wrote:
> > > Since the device file stays open up until all VMAs have been closed
> > > we do not need to increase encl->refcount for VMAs. sgx_open() will
> > > increase it once and sgx_release() will decrease at a point where
> > > the device file is not mapped. anymore.
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > 
> > Cool if I merge this one?
> 
> LGTM

Awesome, merged.

Sent another similar change just now for the page adder. Can you
check that so I can merge.

I have a change in progress that will make the reclaimer also the
reaper and remove the need for the refcount altogether. Try to
get it possibly tonight out (i.e. daytime for you).

/Jarkko

