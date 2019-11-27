Return-Path: <SRS0=fGMY=ZT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0098C432C0
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Nov 2019 21:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F54A2080F
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Nov 2019 21:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731435AbfK0VZa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 Nov 2019 16:25:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:61936 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731771AbfK0VBn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 Nov 2019 16:01:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 13:01:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="383617645"
Received: from gtau-mobl.ger.corp.intel.com (HELO localhost) ([10.251.83.243])
  by orsmga005.jf.intel.com with ESMTP; 27 Nov 2019 13:01:35 -0800
Date:   Wed, 27 Nov 2019 23:01:33 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        Patrick Uiterwijk <puiterwijk@redhat.com>
Subject: Re: [PATCH v23 00/24] Intel SGX foundations
Message-ID: <20191127210133.GC14290@linux.intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <CAOASepNazHxKNrZVP7=oQcCyMNxDH153qfpua95G5dsq9++1aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepNazHxKNrZVP7=oQcCyMNxDH153qfpua95G5dsq9++1aw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 21, 2019 at 10:08:24AM -0500, Nathaniel McCallum wrote:
> The Enarx (https://enarx.io) project is eager to see these patches
> merged. We have tested them on the hardware we have available to us
> and haven't noticed any problems.

There was one regression in reclaimer code in v23. I'm also making a
small API change to v24 i.e. have @count for number of bytes processed
in ADD_PAGES ioctl.

Is it possible to test this in v24 once it is available and potentially
give tested-by to the driver patch if it works for you?

/Jarkko
