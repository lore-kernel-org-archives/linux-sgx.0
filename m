Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717AEC43464
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 12:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 317E320EDD
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 12:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIUMv2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 08:51:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:39063 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgIUMv1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 08:51:27 -0400
IronPort-SDR: 6q+7jjxn5fSutTc1m8J30EwZlpEpgB31kPw6fTeCY/jeYXe13UUQgR5FlooquOn8s7Bj8za0dR
 napvzPhhx6EQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9750"; a="178440425"
X-IronPort-AV: E=Sophos;i="5.77,286,1596524400"; 
   d="scan'208";a="178440425"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 05:51:27 -0700
IronPort-SDR: RjRM4gJiXRdgoJN3d1WKPnh/tUFEQm31NNI2RI2m5nZEjc05peTpx6LodzU6hhR9iWJ7qlOlIK
 M3W8AppvEMxg==
X-IronPort-AV: E=Sophos;i="5.77,286,1596524400"; 
   d="scan'208";a="510675980"
Received: from clairemo-mobl.ger.corp.intel.com (HELO localhost) ([10.252.43.50])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 05:51:20 -0700
Date:   Mon, 21 Sep 2020 15:51:17 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200921125117.GG6038@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-11-jarkko.sakkinen@linux.intel.com>
 <CALCETrX9T1ZUug=M5ba9g4H5B7kV=yL5RzuTaeAEdy3uAieN_A@mail.gmail.com>
 <20200918235337.GA21189@sjchrist-ice>
 <20200921124946.GF6038@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921124946.GF6038@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 03:49:56PM +0300, Jarkko Sakkinen wrote:
> What really should be documented is to answer why we consider an enclave
                                      ~~
				      the (editing mistake)

/Jarkko
