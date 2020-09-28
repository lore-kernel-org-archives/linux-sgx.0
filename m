Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 884E3C2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 20:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4209A20809
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 20:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgI1UUM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 16:20:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:47510 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgI1UUL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 16:20:11 -0400
IronPort-SDR: 0cN3NIEu/paUbSOLJru4vx1lOM+XRo4HUs85BRj56ttqzn0yJz5OKRovOFU5HtCP6833VAsk9/
 i01jg5GUscvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="226203888"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="226203888"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 13:20:08 -0700
IronPort-SDR: BvDsIZdE3iBML0ZvAwcDcXMxeydLNkS68wXKT03yd8xS2rdKFolnSf4DhvYeRrOPyxh5N5bM09
 5Tes3yv5l/6Q==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="488746118"
Received: from jlasecki-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.49.78])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 13:20:01 -0700
Date:   Mon, 28 Sep 2020 23:19:59 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
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
Message-ID: <20200928201959.GA3856@linux.intel.com>
References: <20200925000052.GA20333@linux.intel.com>
 <32fc9df4-d4aa-6768-aa06-0035427b7535@intel.com>
 <20200925194304.GE31528@linux.intel.com>
 <230ce6da-7820-976f-f036-a261841d626f@intel.com>
 <20200928005347.GB6704@linux.intel.com>
 <6eca8490-d27d-25b8-da7c-df4f9a802e87@intel.com>
 <20200928161954.GB92669@linux.intel.com>
 <c29a662e-90ff-4862-8c82-06b43b81fb4d@intel.com>
 <20200928193229.GA125819@linux.intel.com>
 <283800a0-8f97-e21e-2ff1-253ae621747e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <283800a0-8f97-e21e-2ff1-253ae621747e@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 12:45:27PM -0700, Dave Hansen wrote:
> On 9/28/20 12:32 PM, Jarkko Sakkinen wrote:
> > My problem is that I fully agree what you say in your description but
> > disagree on that EMODPE should not be mentioned.
> 
> I'll just be very clear: I'm not willing to ack any patch with a
> changelog that has more than a passing mention of EMODPE.
> 
> Do what you think is best, but if sticking to your guns may deplete the
> pool of folks willing to ack your patch.

I do see it mentioned in other responses too in this thread, and not
just mine.

And here is even a request to get it to the changelog:

https://lore.kernel.org/linux-sgx/1B23E216-0229-4BDD-8B09-807256A54AF5@amacapital.net/

I'm absolutely fine not to mention EMODPE but after re-reading the
thread, it is not like there is one voice on it. I don't really
care all that much whether it is mentioned or not but there should
be some reasonable logic behind the decision.

PS. I just noticed that my previous response did not reach lore so
I bounced it again.

/Jarkko
