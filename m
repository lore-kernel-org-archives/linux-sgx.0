Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BFDC4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 19:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EFBA221EB
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 19:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgIXT3O (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 15:29:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:55271 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728718AbgIXT3N (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 15:29:13 -0400
IronPort-SDR: 0s7WgU6aLPCoXtkDhXLUm+FJTeUUZ25DhQe9KPeQjqswSw1GSL1GPO1a70rtP+7UWwuDyiMEFw
 MQcLvNkfOkqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="162222615"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="162222615"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 12:28:55 -0700
IronPort-SDR: /alJgHdzpr6m/E8oOg3GkCjvnAxXz1fHnWK/iozNJcTJB92wSlAKm5CGN1sqhOgLh0TVuK+3Qa
 1UHE7REBvP9Q==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455484772"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 12:28:55 -0700
Date:   Thu, 24 Sep 2020 12:28:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Message-ID: <20200924192853.GA18826@linux.intel.com>
References: <20200918235337.GA21189@sjchrist-ice>
 <20200921124946.GF6038@linux.intel.com>
 <20200921165758.GA24156@linux.intel.com>
 <20200921210736.GB58176@linux.intel.com>
 <20200921211849.GA25403@linux.intel.com>
 <20200922052957.GA97272@linux.intel.com>
 <20200922053515.GA97687@linux.intel.com>
 <20200922164301.GB30874@linux.intel.com>
 <20200923135056.GD5160@linux.intel.com>
 <op.0rgp5h0hwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0rgp5h0hwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 02:11:37PM -0500, Haitao Huang wrote:
> On Wed, 23 Sep 2020 08:50:56 -0500, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >I'll categorically deny noexec in the next patch set version.
> >
> >/Jarkko
> 
> There are use cases supported currently in which enclave binary is received
> via IPC/RPC and held in buffers before EADD. Denying noexec altogether would
> break those, right?

No.  noexec only applies to file-backed VMAs, what you're describing is loading
an enclave from an anon VMA, which will still have VM_MAYEXEC.

I believe you're thinking of SELinux's EXECMEM, which is required to execute
from anonymous memory, and which we talked about (more than once) applying to
SGX enclaves.

That being said, I still dislike the idea of requiring VM_MAYEXEC, it's a hack
that doesn't really buy us much, if anything.
