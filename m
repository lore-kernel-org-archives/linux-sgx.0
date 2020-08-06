Return-Path: <SRS0=kl42=BQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DA2C433DF
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 16:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 085D923119
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 16:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fMZZkvsC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgHFQt0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:49:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48122 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728369AbgHFQlS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Aug 2020 12:41:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076GMLNN144181;
        Thu, 6 Aug 2020 16:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=bLAwo3t/sI0fgU4hBFxE/B5ggB+vGc0PRdO6iJd4HG4=;
 b=fMZZkvsCh61h9GQZEuHhD0CRMWNQaO3IJFp7ixpZ1PdE2I/wyj4Xo7WUufm9Wy2tHshs
 e6DfsEm0KI3LjAtx5vLRlJgLMMkTruR5D/Y2ZAqC/0FCvzDJhUg6jfvnDjbqPcS/uRd0
 KzySovDMkqSL8buJHJT/tBY8eBwizvghufi5v8LLe3W2ntlQ0lPH9Z9Rkb+ls4XAMzSf
 AMPzvi4S4WSXa/jCjklrD2RKd7oymb22mr7gvcwsOVsXipVebx6vYKWbWbOxWAqVHF3F
 eaXdH73ZoP0WYoI50161JJcaSB5ap7wbhzWfEkbvNtqi614Q1FJ86zRMANHcPdSmXJ75 ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32r6ep44rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 16:40:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076GO6Bl154050;
        Thu, 6 Aug 2020 16:40:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32r6cvrhk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 16:40:45 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 076Gee0f029639;
        Thu, 6 Aug 2020 16:40:40 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 09:40:39 -0700
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id C9C60F09834; Thu,  6 Aug 2020 17:40:19 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 14/24] x86/sgx: Add SGX_IOC_ENCLAVE_INIT
In-Reply-To: <20200716135303.276442-15-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-15-jarkko.sakkinen@linux.intel.com>
Date:   Thu, 06 Aug 2020 17:40:19 +0100
Message-ID: <m2a6z7ramk.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 bulkscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060113
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thursday, 2020-07-16 at 16:52:53 +03, Jarkko Sakkinen wrote:
> Add an ioctl that performs ENCLS[EINIT], which locks down the measurement
> and initializes the enclave for entrance. After this, new pages can no
> longer be added.
>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Tested-by: Jethro Beekman <jethro@fortanix.com>
> Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
> Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
> Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
> Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
> Tested-by: Seth Moore <sethmo@google.com>

Tested-by: Darren Kenny <darren.kenny@oracle.com>
Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/include/uapi/asm/sgx.h |  11 ++
>  arch/x86/kernel/cpu/sgx/ioctl.c | 188 ++++++++++++++++++++++++++++++++
>  2 files changed, 199 insertions(+)
>
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index c8f199b3fb6f..5edb08ab8fd0 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -23,6 +23,8 @@ enum sgx_page_flags {
>  	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
>  #define SGX_IOC_ENCLAVE_ADD_PAGES \
>  	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
> +#define SGX_IOC_ENCLAVE_INIT \
> +	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
>  
>  /**
>   * struct sgx_enclave_create - parameter structure for the
> @@ -52,4 +54,13 @@ struct sgx_enclave_add_pages {
>  	__u64	count;
>  };
>  
> +/**
> + * struct sgx_enclave_init - parameter structure for the
> + *                           %SGX_IOC_ENCLAVE_INIT ioctl
> + * @sigstruct:	address for the SIGSTRUCT data
> + */
> +struct sgx_enclave_init {
> +	__u64 sigstruct;
> +};
> +
>  #endif /* _UAPI_ASM_X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index c63a51362d14..3444de955191 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -16,6 +16,9 @@
>  #include "encl.h"
>  #include "encls.h"
>  
> +/* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
> +static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
> +
>  static u32 sgx_calc_ssa_frame_size(u32 miscselect, u64 xfrm)
>  {
>  	u32 size_max = PAGE_SIZE;
> @@ -485,6 +488,188 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
>  	return ret;
>  }
>  
> +static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
> +			      void *hash)
> +{
> +	SHASH_DESC_ON_STACK(shash, tfm);
> +
> +	shash->tfm = tfm;
> +
> +	return crypto_shash_digest(shash, modulus, SGX_MODULUS_SIZE, hash);
> +}
> +
> +static int sgx_get_key_hash(const void *modulus, void *hash)
> +{
> +	struct crypto_shash *tfm;
> +	int ret;
> +
> +	tfm = crypto_alloc_shash("sha256", 0, CRYPTO_ALG_ASYNC);
> +	if (IS_ERR(tfm))
> +		return PTR_ERR(tfm);
> +
> +	ret = __sgx_get_key_hash(tfm, modulus, hash);
> +
> +	crypto_free_shash(tfm);
> +	return ret;
> +}
> +
> +static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
> +{
> +	u64 *cache;
> +	int i;
> +
> +	cache = per_cpu(sgx_lepubkeyhash_cache, smp_processor_id());
> +	for (i = 0; i < 4; i++) {
> +		if (enforce || (lepubkeyhash[i] != cache[i])) {
> +			wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
> +			cache[i] = lepubkeyhash[i];
> +		}
> +	}
> +}
> +
> +static int sgx_einit(struct sgx_sigstruct *sigstruct, void *token,
> +		     struct sgx_epc_page *secs, u64 *lepubkeyhash)
> +{
> +	int ret;
> +
> +	preempt_disable();
> +	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
> +	ret = __einit(sigstruct, token, sgx_get_epc_addr(secs));
> +	if (ret == SGX_INVALID_EINITTOKEN) {
> +		sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);
> +		ret = __einit(sigstruct, token, sgx_get_epc_addr(secs));
> +	}
> +	preempt_enable();
> +	return ret;
> +}
> +
> +static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
> +			 void *token)
> +{
> +	u64 mrsigner[4];
> +	int ret;
> +	int i;
> +	int j;
> +
> +	/* Check that the required attributes have been authorized. */
> +	if (encl->secs_attributes & ~encl->allowed_attributes)
> +		return -EACCES;
> +
> +	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&encl->lock);
> +
> +	/*
> +	 * Periodically, EINIT polls for certain asynchronous events. If such an
> +	 * event is detected, it completes with SGX_UNMSKED_EVENT.
> +	 */
> +	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
> +		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
> +			ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
> +					mrsigner);
> +			if (ret == SGX_UNMASKED_EVENT)
> +				continue;
> +			else
> +				break;
> +		}
> +
> +		if (ret != SGX_UNMASKED_EVENT)
> +			break;
> +
> +		msleep_interruptible(SGX_EINIT_SLEEP_TIME);
> +
> +		if (signal_pending(current)) {
> +			ret = -ERESTARTSYS;
> +			goto err_out;
> +		}
> +	}
> +
> +	if (ret & ENCLS_FAULT_FLAG) {
> +		if (encls_failed(ret))
> +			ENCLS_WARN(ret, "EINIT");
> +
> +		sgx_encl_destroy(encl);
> +		ret = -EFAULT;
> +	} else if (ret) {
> +		pr_debug("EINIT returned %d\n", ret);
> +		ret = -EPERM;
> +	} else {
> +		atomic_or(SGX_ENCL_INITIALIZED, &encl->flags);
> +	}
> +
> +err_out:
> +	mutex_unlock(&encl->lock);
> +	return ret;
> +}
> +
> +/**
> + * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
> + *
> + * @filep:	open file to /dev/sgx
> + * @arg:	userspace pointer to a struct sgx_enclave_init instance
> + *
> + * Flush any outstanding enqueued EADD operations and perform EINIT.  The
> + * Launch Enclave Public Key Hash MSRs are rewritten as necessary to match
> + * the enclave's MRSIGNER, which is caculated from the provided sigstruct.
> + *
> + * Return:
> + *   0 on success,
> + *   SGX error code on EINIT failure,
> + *   -errno otherwise
> + */
> +static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
> +{
> +	struct sgx_sigstruct *sigstruct;
> +	struct sgx_enclave_init einit;
> +	struct page *initp_page;
> +	void *token;
> +	int ret;
> +
> +	if ((atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) ||
> +	    !(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&einit, arg, sizeof(einit)))
> +		return -EFAULT;
> +
> +	initp_page = alloc_page(GFP_KERNEL);
> +	if (!initp_page)
> +		return -ENOMEM;
> +
> +	sigstruct = kmap(initp_page);
> +	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
> +	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
> +
> +	if (copy_from_user(sigstruct, (void __user *)einit.sigstruct,
> +			   sizeof(*sigstruct))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	/*
> +	 * A legacy field used with Intel signed enclaves. These used to mean
> +	 * regular and architectural enclaves. The CPU only accepts these values
> +	 * but they do not have any other meaning.
> +	 *
> +	 * Thus, reject any other values.
> +	 */
> +	if (sigstruct->header.vendor != 0x0000 &&
> +	    sigstruct->header.vendor != 0x8086) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ret = sgx_encl_init(encl, sigstruct, token);
> +
> +out:
> +	kunmap(initp_page);
> +	__free_page(initp_page);
> +	return ret;
> +}
> +
> +
>  long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  {
>  	struct sgx_encl *encl = filep->private_data;
> @@ -506,6 +691,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  	case SGX_IOC_ENCLAVE_ADD_PAGES:
>  		ret = sgx_ioc_enclave_add_pages(encl, (void __user *)arg);
>  		break;
> +	case SGX_IOC_ENCLAVE_INIT:
> +		ret = sgx_ioc_enclave_init(encl, (void __user *)arg);
> +		break;
>  	default:
>  		ret = -ENOIOCTLCMD;
>  		break;
> -- 
> 2.25.1
