Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F99EC2BA1A
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 21:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C9F52072A
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 21:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgDFVYz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 17:24:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:23606 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgDFVYy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 17:24:54 -0400
IronPort-SDR: 2mXMjMPsvVg3bEFGyOwT5rD31H/XPOz+3TlDn1nqk6N4uKLz8jiAZ5v+pHQa5XQBIDKba0oc3L
 sDJDXLoHEu3Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 14:24:53 -0700
IronPort-SDR: wXmHyhx9LkwKGP3PO6ekENkSbIFkRuJ8fMQMiPiarparZnqEi5MRWnHWRChShB6oejCI1PDnUU
 be8P2PrN3Shw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,352,1580803200"; 
   d="scan'208";a="274876511"
Received: from hmer-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.39.225])
  by fmsmga004.fm.intel.com with ESMTP; 06 Apr 2020 14:24:46 -0700
Date:   Tue, 7 Apr 2020 00:24:34 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200406212434.GA34134@linux.intel.com>
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 06, 2020 at 12:53:41PM -0700, Andy Lutomirski wrote:
> > sgxfs is somewhat trivial to implement and has one stakeholder less to
> > worry about. It is not really a huge stretch.
> > 
> > Overally, I think it is something that we could live with. At least it
> > is something that does not step on others toes.
> > 
> > Haitao: If we go with sgxfs route, then you can for the moment do what
> > Andy suggested: bind mount it to /dev/sgx.
> 
> That also needs userspace support.
> 
> I’ll start a thread on the udev list.

Haven't written any code yet but just by drafting the idea I already
pinpointed something.

You would add roughly this to the existing codebase:

* struct file_system_type sgxfs
* struct fs_context_operations sgxfs_ctx_ops
* int sgxfs_get_tree()
* int sgxfs_fill_super()
* const struct tree_descr sgxfs_files[]

The files would be defined as like this:

static const struct tree_descr sgxfs_files[] {
	[SGXFS_ENCLAVE] = { "enclave", &sgxfs_encl_ops, /* ? */ },
	[SGXFS_PROVISION] = { "provision", &sgxfs_encl_ops, /* ? */ },
};

The permissions would need to be completely static, which feels nasty
from maintainability viewpoint :-( And I see no gain anywhere.

In my opinion udev defining the whole /dev as noexec has zero technical
merits. It is same as they would say that "we don't trust our own
database". There are no real security benefits as long as dev nodes are
configured correctly.

/Jarkko
