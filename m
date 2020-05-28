Return-Path: <SRS0=sWWJ=7K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCBDC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 07:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27DBA206B6
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 07:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgE1Hgk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 May 2020 03:36:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:21221 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE1Hgj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 May 2020 03:36:39 -0400
IronPort-SDR: en6LipV8WWAPD6lIVlYbRzhStaa8Z40cWR71BCqElICsstWxAP+eV++XO6ZEengT8mq2QjYZD/
 jLQG3E1alQTQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:36:39 -0700
IronPort-SDR: DnLZQn9vlvIMm+BBthxvPIxdmKPkvIONmEgh7zQqOfo6IEVuPKIaXlPC6WLifraxx+rO8EEnY4
 7dPiBu+KiFCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,444,1583222400"; 
   d="scan'208";a="469025063"
Received: from dmescala-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.59.102])
  by fmsmga005.fm.intel.com with ESMTP; 28 May 2020 00:36:30 -0700
Date:   Thu, 28 May 2020 10:36:28 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Serge Ayoun <serge.ayoun@intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 07/20] x86/sgx: Enumerate and track EPC sections
Message-ID: <20200528073628.GA291560@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-8-jarkko.sakkinen@linux.intel.com>
 <20200525092304.GD25636@zn.tnic>
 <20200527035613.GH31696@linux.intel.com>
 <20200527203509.GF1721@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527203509.GF1721@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 27, 2020 at 10:35:09PM +0200, Borislav Petkov wrote:
 
> > One idea would be to provide a Kconfig a la NR_CPUS or NODES_SHIFT.  I.e.
> > carve out the bits in sgx_epc_page_desc to allow up to N sections, but let
> > the user limit the number of sections to recoup the unused memory.
> 
> I'd prefer a good estimate of a highest value, say 8 bits, which should
> suffice for the foreseeable future. That's the simplest thing to do and
> our Kconfig symbols space is an abomination of gazillion symbols.

OK, will do.

/Jarkko
