Return-Path: <SRS0=xaf1=3C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52A6C33CA8
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 03:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C15221744
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 03:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbgAMD7W (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 12 Jan 2020 22:59:22 -0500
Received: from mga14.intel.com ([192.55.52.115]:27136 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387415AbgAMD7W (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 12 Jan 2020 22:59:22 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jan 2020 19:59:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,427,1571727600"; 
   d="scan'208";a="219189076"
Received: from akurtz1-mobl.ger.corp.intel.com (HELO localhost) ([10.252.10.99])
  by fmsmga008.fm.intel.com with ESMTP; 12 Jan 2020 19:59:20 -0800
Date:   Mon, 13 Jan 2020 05:59:18 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: v25-rc1
Message-ID: <20200113035918.GA32455@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

I tagged v25-rc1:

* Fix a double-free issue when SGX_IOC_ENCLAVE_ADD_PAGES
  fails on executing ENCLS[EADD]. The rollback path executed
  radix_tree_delete() on the same address twice when this happened.
* Return -EINTR instead of -ERESTARTSYS in SGX_IOC_ENCLAVE_ADD_PAGES when
  a signal is pending.
* As requested by Borislav, move the CPUID 0x12 features to their own word
  in cpufeatures.
* Sean fixed a bug from sgx_reclaimer_write() where sgx_encl_put_backing()
  was called with an uninitialized pointer when sgx_encl_get_backing()
  fails.
* Migrated /dev/sgx/* to misc. This is future-proof as struct miscdevice
  has 'groups' for setting up sysfs attributes for the device.
* Use device_initcall instead of subsys_initcall so that misc_class is
  initialized before SGX is initialized.

Before final v25, this patch set needs to reach mainline:

https://lore.kernel.org/kvm/20191221044513.21680-1-sean.j.christopherson@intel.com

In the meanwhile I'll concentrate on going through with eyeglass all
Borislav's feedback for v23 and v24.

/Jarkko
