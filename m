Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE628C2B9F4
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Jun 2021 00:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9ED8613BF
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Jun 2021 00:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhFRAHJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Jun 2021 20:07:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:33072 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhFRAHJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 17 Jun 2021 20:07:09 -0400
IronPort-SDR: Rpr08j2/ol9jx/CD0Ao1oC+O01rGTlFytqp5/Uy5+dbUg+bmbOd9L+jueSGBM97nAZ7iUrQOh5
 6bKEhtEFXkVA==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="292100794"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="292100794"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 17:05:00 -0700
IronPort-SDR: FQN3PIfmCZoxvzc1kdisBfp0lxADEtXxdM3KXpZgU6Vw/Ai6SiIPg3t27pQxpsgii8ImCLt2xc
 A0AmcLOUs/YA==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="422039738"
Received: from doglesby-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.38.109])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 17:04:57 -0700
Message-ID: <88eb26df062c473a6bffe5a0e1299f75e6a3cb78.camel@intel.com>
Subject: Re: [PATCH] x86/sgx: Add missing xa_destroy() when virtual EPC is
 destroyed
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
        dave.hansen@intel.com, tglx@linutronix.de, mingo@redhat.com,
        Yang Zhong <yang.zhong@intel.com>
Date:   Fri, 18 Jun 2021 12:04:55 +1200
In-Reply-To: <YMtdWduyALHxggoP@zn.tnic>
References: <20210615101639.291929-1-kai.huang@intel.com>
         <20210615132001.kd6cuktq37dvoq3l@kernel.org>
         <618b42d66a4f2087ef4c54cc50fd56d01233eab1.camel@intel.com>
         <YMtdWduyALHxggoP@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-06-17 at 16:34 +0200, Borislav Petkov wrote:
> On Wed, Jun 16, 2021 at 12:30:04PM +1200, Kai Huang wrote:
> > Thanks Jarkko. I literally need to find some way to avoid such error in future :)
> 
> That way is called "integrate checkpatch.pl into your patch creation
> workflow".
> 

Thanks for suggestion. Yes I actually did the checkpatch.pl, but it didn't report typo in
commit message.  A little bit strange.

