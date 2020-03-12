Return-Path: <SRS0=mz4j=45=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09C3C10DCE
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Mar 2020 18:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA7692067C
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Mar 2020 18:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgCLSi0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Mar 2020 14:38:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:2360 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgCLSi0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Mar 2020 14:38:26 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 11:38:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="236715869"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 12 Mar 2020 11:38:24 -0700
Date:   Thu, 12 Mar 2020 11:38:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-mm@kvack.org, Ismo Puustinen <ismo.puustinen@intel.com>,
        Mark Shanahan <mark.shanahan@intel.com>,
        Mikko Ylinen <mikko.ylinen@intel.com>,
        Derek Bombien <derek.bombien@intel.com>
Subject: Re: [PATCH v28 16/22] x86/sgx: Add a page reclaimer
Message-ID: <20200312183824.GB26453@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-17-jarkko.sakkinen@linux.intel.com>
 <20200305190354.GK11500@linux.intel.com>
 <20200306184702.GD7472@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306184702.GD7472@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 06, 2020 at 08:47:02PM +0200, Jarkko Sakkinen wrote:
> On Thu, Mar 05, 2020 at 11:03:54AM -0800, Sean Christopherson wrote:
> > We've also discussed taking a file descriptor to hold the backing, but
> > unless I'm misreading the pagecache code, that doesn't solve the incorrect
> > accounting problem because the current task, i.e. evicting task, would be
> > charged.  In other words, whether the backing is kernel or user controlled
> > is purely an ABI question.
> 
> Even if the file is owned by a different process the account happens
> to "current"?

Yes.  Which makes sense as files do not have a 1:1 association with tasks.
