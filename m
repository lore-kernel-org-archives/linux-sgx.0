Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFA9C43219
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 03:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3008C2388B
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 03:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbhAUDhF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 22:37:05 -0500
Received: from mga12.intel.com ([192.55.52.136]:49637 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404376AbhATXyl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Jan 2021 18:54:41 -0500
IronPort-SDR: rk6AjYQjHe7w6AL1ojsy0EAO8sNK26KMrhS0r5eZ89rPi/duGzZ2CNJ5wjXlnAWUriLYFlqDEE
 5rnOEmyGbpGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="158373263"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="158373263"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:53:56 -0800
IronPort-SDR: OA4mnu1kyqex8h4uCe3P+3+MQ3Vr/KwBLVvNJCcbv+a1RGYHCnJctLy9zpiZkjBLxvE6lLCzSN
 /sWzJvNXgslA==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="407067110"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:53:52 -0800
Date:   Thu, 21 Jan 2021 12:53:50 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com
Subject: Re: [RFC PATCH v2 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Message-Id: <20210121125350.0bdc860aea82c120fddfb680@intel.com>
In-Reply-To: <YAga+PoOrl9bEQN9@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
        <25746564cb0a719a69b6138d8004b987a5e0bc91.1610935432.git.kai.huang@intel.com>
        <YAga+PoOrl9bEQN9@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 20 Jan 2021 13:58:48 +0200 Jarkko Sakkinen wrote:
> On Mon, Jan 18, 2021 at 04:27:49PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > KVM will use many of the architectural constants and structs to
> > virtualize SGX.
> 
> "Expose SGX architectural structures, as ..."

Will do.

