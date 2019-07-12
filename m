Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B68C742A2
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D781420645
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfGLDN0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 23:13:26 -0400
Received: from namei.org ([65.99.196.166]:34784 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbfGLDN0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 23:13:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id x6C3CNjx022046;
        Fri, 12 Jul 2019 03:12:23 GMT
Date:   Fri, 12 Jul 2019 13:12:23 +1000 (AEST)
From:   James Morris <jmorris@namei.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Some LSM and SGX remarks before parting of for two weeks
In-Reply-To: <20190712021055.22qijpsahsy3gpmp@linux.intel.com>
Message-ID: <alpine.LRH.2.21.1907121303080.17953@namei.org>
References: <20190712021055.22qijpsahsy3gpmp@linux.intel.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 12 Jul 2019, Jarkko Sakkinen wrote:

> Before going to a two week vacation (sending v21 today), I'll make some
> remarks on SGX and LSM's:
> 
> 1. Currently all patch sets proposing LSM changes are missing a problem
>    statement and describe a solution to an undescribed problem.
> 2. When speaking of SELinux I haven't seen any draft's on how would
>    define a policy module with the new constructs. Does not have to
>    be a full policy modules but more like snippets demosntrating that
>    "this would work".
> 3. All the SELinux discussion is centered on type based policies.
>    Potentially one could isolate enclaves with some UBAC or RBAC
>    based model. That could be good first step and might not even
>    require LSM changes.

Unless I misunderstand what you mean here, RBAC and UBAC in SELinux still 
require LSM hooks, and are typically integrated with Type Enforcement.



-- 
James Morris
<jmorris@namei.org>

