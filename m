Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C15EC4727E
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 19:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B108222BB
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 19:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgIUT6e (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 15:58:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:6567 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727197AbgIUT6b (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 15:58:31 -0400
IronPort-SDR: lSsMAJfz9GNJcYE0NFmcHXpJwQGAAu12gG1N/XBhMyr++zV6clBjPL6fA90SzXqCF4+rsXo6um
 9rG8nYk7jWGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="161391879"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="161391879"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 12:58:30 -0700
IronPort-SDR: rAEqZ+YlzVG9mAhqVrqnE3X93fmpOiEzu0W+Q11CidGTPAHHF3PI4Yf1ELoMf4L5q51aAEUrYS
 uku4r5JKn0VA==
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="485647966"
Received: from kofels-mobl.ger.corp.intel.com (HELO localhost) ([10.249.45.179])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 12:58:23 -0700
Date:   Mon, 21 Sep 2020 22:58:22 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20200921195822.GA58176@linux.intel.com>
References: <20200917160206.GF8530@linux.intel.com>
 <op.0q3pw0stwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200918020940.GA14678@sjchrist-ice>
 <20200918122029.GA27028@linux.intel.com>
 <20200918123932.GB27028@linux.intel.com>
 <20200919000918.GB21189@sjchrist-ice>
 <20200921114104.GB6038@linux.intel.com>
 <20200921164647.GC23989@linux.intel.com>
 <20200921184948.GA49586@linux.intel.com>
 <20200921194419.GA56547@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921194419.GA56547@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 10:44:19PM +0300, Jarkko Sakkinen wrote:
> On Mon, Sep 21, 2020 at 09:49:48PM +0300, Jarkko Sakkinen wrote:
> > To have understandable semantics you have to map error codes to
> > conditions rather than opcodes. -EIO means loss of enclave in the event
> > of EPC gone invalid. Enclave is already lost, that is the reason why we
> > deinitialize the kernel data structures.
> > 
> > EADD must have a different error code because nothing is actually lost
> > but the failure conditions are triggered outside. -EFAULT would be
> > probably the most reasonable choice for that.
> 
> Now that I did all the changes discussed and then I remember why EADD
> and EEXTEND had a common error code, and common behaviour. Obviously EADD
> can also fail because of EPC reset because it depends on a valid SECS
> page.
> 
> If we cannot distinct from EADD caused by EPC loss and EADD caused by
> problems with the source, it should have the same error code, and also
> the enclave should be deinitialized, whenver this happens.
> 
> So I would just revert to v38 behaviour, keeping of course the whole
> check more visible in sgx_ioc_enclave_add_pages(), and just refine
> the documentation better describe the whole situation.

So now the behaviour is reverted back to same as it was before [*] and
I refined the documenation as:

"
 * The function deinitializes kernel data structures for enclave and returns
 * -EIO in any of the following conditions:
 *
 * - Enclave Page Cache (EPC), the physical memory holding enclaves, has
 *   been invalidated. This will cause EADD and EEXTEND to fail.
 * - If the source address is corrupted somehow when executing EADD.
"

[*] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git/tree/arch/x86/kernel/cpu/sgx/ioctl.c

/Jarkko
